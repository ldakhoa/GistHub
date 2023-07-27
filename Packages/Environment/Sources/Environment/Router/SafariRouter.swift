import SwiftUI
import SafariServices

extension View {
    public func withSafariRouter() -> some View {
        modifier(SafariRouter())
    }
}

private struct SafariRouter: ViewModifier {
    @EnvironmentObject private var routerPath: RouterPath
    @EnvironmentObject private var userDefaultsStore: UserDefaultsStore
    @StateObject private var webView = GistHubWebView()

    func body(content: Content) -> some View {
        content
            .environment(\.openURL, OpenURLAction { url in
                // Open internal URL
                routerPath.handle(url: url)
            })
            .onOpenURL { url in
                // Open external URL (from gisthub://)
                let urlString = url.absoluteString.replacingOccurrences(
                    of: "gisthub://",
                    with: "https://"
                )
                guard let url = URL(string: urlString), url.host != nil else { return }
                routerPath.handle(url: url)
            }
            .onAppear {
                routerPath.urlHandler = { url in
                    guard !userDefaultsStore.openExternalsLinksInSafari else { return .systemAction }
                    return webView.open(url)
                }
            }
            .background {
                WindowReader { window in
                    webView.windowScene = window.windowScene
                }
            }
    }
}
