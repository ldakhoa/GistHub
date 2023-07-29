import SwiftUI
import SafariServices

extension View {
    public func withSafariRouter(isActiveTab: Bool) -> some View {
        modifier(SafariRouter(isActiveTab: isActiveTab))
    }
}

private struct SafariRouter: ViewModifier {
    @EnvironmentObject private var routerPath: RouterPath
    @EnvironmentObject private var userDefaultsStore: UserDefaultsStore
    @StateObject private var webView = GistHubWebView()

    private let isActiveTab: Bool

    init(isActiveTab: Bool) {
        self.isActiveTab = isActiveTab
    }

    func body(content: Content) -> some View {
        content
            .environment(\.openURL, OpenURLAction { url in
                guard isActiveTab else { return .discarded }
                // Open internal URL
                return routerPath.handle(url: url)
            })
            .onOpenURL { url in
                guard isActiveTab else { return }

                // Open external URL (from gisthub://)
                let urlString = url.absoluteString.replacingOccurrences(
                    of: "gisthub://",
                    with: "https://"
                )
                guard let url = URL(string: urlString), url.host != nil else { return }
                routerPath.handle(url: url)
            }
            .onAppear {
                guard isActiveTab else { return }

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
