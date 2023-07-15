//
//  ActionRequestHandler.swift
//  GistHubActionExtension
//
//  Created by Khoa Le on 15/07/2023.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import Models

final class ActionRequestHandler: NSObject, NSExtensionRequestHandling, Sendable {
    func beginRequest(with context: NSExtensionContext) {
        // Do not call super in an Action extension with no user interface
        Task {
            do {
                let url = try await url(from: context)
                print("URL from extension \(url)")
                
                guard url.isGistGitHubInstance else {
                    throw Error.notGistInstance
                }
                
                await MainActor.run {
                    let deeplink = url.gistHubAppDeepLink
                    let output = output(wrapping: deeplink)
                    context.completeRequest(returningItems: output)
                }
            } catch {
                await MainActor.run {
                    context.completeRequest(returningItems: [])
                }
            }
        }
    }
}

extension ActionRequestHandler {
    enum Error: Swift.Error {
        case notGistInstance
        case urlNotFound
        case loadedItemHasWrongType
        case inputProviderNotFound
        case noHost
    }
}

extension ActionRequestHandler {
    /// Looking for an input item that might provide the plist that JavaScript sent.
    private func url(from context: NSExtensionContext) async throws -> URL {
        for item in context.inputItems as! [NSExtensionItem] {
            guard let attachments = item.attachments else { continue }
            
            for itemProvider in attachments {
                guard itemProvider.hasItemConformingToTypeIdentifier(UTType.propertyList.identifier) else {
                    continue
                }
                
                guard let dictionary = try await itemProvider.loadItem(forTypeIdentifier: UTType.propertyList.identifier) as? [String: Any] else {
                    throw Error.loadedItemHasWrongType
                }
                
                let input = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! [String: Any]? ?? [:]
                
                guard
                    let absoluteStringURL = input["url"] as? String,
                    let url = URL(string: absoluteStringURL)
                else {
                    throw Error.urlNotFound
                }
                return url
            }
        }

        throw Error.inputProviderNotFound
    }

    /// Wrap the output to the expected object so we send back results to JS
    private func output(wrapping deeplink: URL) -> [NSExtensionItem] {
        let results = ["deeplink": deeplink.absoluteString]
        let dictionary = [NSExtensionJavaScriptFinalizeArgumentKey: results]
        let provider = NSItemProvider(
            item: dictionary as NSDictionary,
            typeIdentifier: UTType.propertyList.identifier
        )
        let item = NSExtensionItem()
        item.attachments = [provider]
        return [item]
    }
}

extension URL {
    var gistHubAppDeepLink: URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        components.scheme = AppInfo.scheme.trimmingCharacters(in: [":", "/"])
        return components.url!
    }

    var isGistGitHubInstance: Bool {
        guard let host = host() else {
            return false
        }
        return host == "gist.github.com"
    }
}

extension NSExtensionContext: @unchecked Sendable {}
