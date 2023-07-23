import SwiftUI

extension View {
    public func withSafariRouter() -> some View {
        modifier(SafariRouter())
    }
}

private struct SafariRouter: ViewModifier {
    @EnvironmentObject private var routerPath: RouterPath

    func body(content: Content) -> some View {
        content
            .environment(\.openURL, OpenURLAction { url in
                // Open internal URL
                routerPath.handle(url: url)
            })
            .onOpenURL { url in
                // Open external URL (from gisthub://)
                let urlString = url.absoluteString.replacingOccurrences(of: "gisthub://", with: "https://")
                guard let url = URL(string: urlString), url.host != nil else { return }
                routerPath.handle(url: url)
            }
    }
}
