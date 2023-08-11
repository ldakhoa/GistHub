import SwiftUI

public struct EmptyStatefulView: View {
    private let title: String

    public init(title: String) {
        self.title = title
    }

    public var body: some View {
        Text(title)
            .font(.title3)
            .bold()
    }
}
