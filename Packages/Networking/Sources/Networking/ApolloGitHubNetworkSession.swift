//
//  ApolloGitHubNetworkSession.swift
//
//
//  Created by Hung Dao on 22/07/2023.
//

import Foundation
import Apollo
import GistHubAPI
import AppAccount
import os

public class ApolloGitHubNetworkSession {
    public static let shared = ApolloGitHubNetworkSession()

    public lazy var apollo: ApolloClient = {
        let url = URL(string: "https://api.github.com/graphql")!
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let sessionClient = URLSessionClient()
        let provider = NetworkInterceptorProvider(client: sessionClient, shouldInvalidateClientOnDeinit: true, store: store)
        let requestChainTransport = RequestChainNetworkTransport(interceptorProvider: provider,
                                                                 endpointURL: url)

        return ApolloClient(networkTransport: requestChainTransport,
                            store: store)
    }()
}

class NetworkInterceptorProvider: DefaultInterceptorProvider {
    override func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(AuthorizationInterceptor(), at: 0)
        return interceptors
    }
}

class AuthorizationInterceptor: ApolloInterceptor {
    var id: String = ""

    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Swift.Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
            let appAccountsManager = AppAccountsManager()
            guard let focusedUserSession = appAccountsManager.focusedAccount else { return }
            request.addHeader(name: "Authorization", value: "bearer \(focusedUserSession.token)")
            chain.proceedAsync(request: request,
                               response: response,
                               interceptor: self,
                               completion: completion)
        }
}

public struct ApolloError: LocalizedError {
    public var errorDescription: String? {
        return "Errors occurred while fetching data"
    }
}