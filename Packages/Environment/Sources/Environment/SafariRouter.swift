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
    }
}
