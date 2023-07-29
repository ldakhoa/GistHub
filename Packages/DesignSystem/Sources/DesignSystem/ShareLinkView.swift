import SwiftUI

public struct ShareLinkView: View {
    private let itemString: String
    private let previewTitle: String
    private let labelTitle: String

    public init(
        itemString: String,
        previewTitle: String,
        labelTitle: String = "Share via..."
    ) {
        self.itemString = itemString
        self.previewTitle = previewTitle
        self.labelTitle = labelTitle
    }

    public var body: some View {
        ShareLink(
            item: itemString,
            preview: SharePreview(previewTitle, image: Image("default"))
        ) {
            Label(labelTitle, systemImage: "square.and.arrow.up")
        }
    }
}
