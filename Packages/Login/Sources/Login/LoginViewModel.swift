//
//  LoginViewModel.swift
//  GistHub
//
//  Created by Khoa Le on 16/12/2022.
//

import AuthenticationServices
import SwiftUI
import Combine
import AppAccount
import Networking
import Utilities
import Environment

public protocol LoginDelegate: AnyObject {
    func finishLogin(token: String, authMethod: AuthMethod, username: String)
}

final class LoginViewModel: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    @Published var contentState: ContentState = .idling
    @Published var finishLogin: Bool = false

    var appAccountsManager: AppAccountsManager?

    // MARK: - Login URL

    private let loginURL = URLBuilder.github()
        .add(paths: ["login", "oauth", "authorize"])
        .add(item: "client_id", value: Secrets.GitHub.clientId)
        .add(item: "scope", value: "user+repo+gist+notifications")
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
                        let appAccount: AppAccount = AppAccount(
                            token: response.token,
                            authMethod: .oauth,
                            username: response.username
                        )
                        self?.appAccountsManager?.focus(appAccount)
                        self?.contentState = .idling
                        self?.finishLogin = true
                    case .failure:
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
            let appAccount: AppAccount = AppAccount(
                token: token,
                authMethod: .pat,
                username: user.login ?? ""
            )
            self.appAccountsManager?.focus(appAccount)

            if user.id != nil {
                contentState = .idling
                finishLogin = true
            }
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
