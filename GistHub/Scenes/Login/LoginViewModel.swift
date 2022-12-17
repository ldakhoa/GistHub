//
//  LoginViewModel.swift
//  GistHub
//
//  Created by Khoa Le on 16/12/2022.
//

import AuthenticationServices
import SwiftUI
import Combine

final class LoginViewModel: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    @Published var contentState: ContentState = .idling

    // MARK: - Login URL

    private let loginURL = URLBuilder.github()
        .add(paths: ["login", "oauth", "authorize"])
        .add(item: "client_id", value: Secrets.GitHub.clientId)
        .add(item: "scope", value: "user+gist+notifications")
        .url!

    private let callbackURLScheme = "gisthub"

    // MARK: - Utils

    private var cancellables = Set<AnyCancellable>()
    private let client: AccessTokenClient

    // MARK: - Initializer

    init(
        client: AccessTokenClient = DefaultAccessTokenClient()
    ) {
        self.client = client
    }

    // MARK: - ASWebAuthenticationPresentationContextProviding

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }

    // MARK: - Public API

    func login() {
        let signInPromise = Future<URL, Error> { [weak self] completion in
            guard let self = self else { return }

            let authSession = ASWebAuthenticationSession(
                url: self.loginURL,
                callbackURLScheme: self.callbackURLScheme) { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    }
                }
            authSession.presentationContextProvider = self
//            authSession.prefersEphemeralWebBrowserSession = true
            authSession.start()
        }

        signInPromise
            .sink { completion in
            switch completion {
            case let .failure(error):
                self.contentState = .error(error: error.localizedDescription)
            default:
                break
            }
        } receiveValue: { callbackUrl in
            guard
                let items = URLComponents(url: callbackUrl, resolvingAgainstBaseURL: false)?.queryItems,
                let index = items.firstIndex(where: { $0.name == "code" }),
                let code = items[index].value
            else {
                return
            }

            self.contentState = .ghLoading

            self.client.requestAccessToken(code: code) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case let .success(response):
                        print("Login succeed: ", response.token, response.username)
                        self?.contentState = .idling
                    case let .failure(error):
                        print(error.localizedDescription)
                        self?.contentState = .error(error: "An error occured when attempting to sign in.")
                    }
                }
            }
        }
        .store(in: &cancellables)
    }

    @MainActor
    func personalAccessTokenLogin(token: String) async {
        do {
            let user = try await client.verifyPersonalAccessTokenRequest(token: token)
            if user.id != nil {
                contentState = .idling
            }
            print(user.login)
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }
}

extension LoginViewModel {
    enum ContentState: Equatable {
        case idling
        case ghLoading
        case error(error: String)
    }
}
