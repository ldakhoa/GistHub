import SwiftUI
import Kingfisher
import UIKit

public struct GistHubImage: View {
    let url: URL
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat

    public init(
        url: URL,
        width: CGFloat = 24.0,
        height: CGFloat = 24.0,
        cornerRadius: CGFloat = 12.0
    ) {
        self.url = url
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        KFImage.url(url)
            .placeholder {
                Rectangle()
                    .foregroundColor(Colors.neutralEmphasis.color)
                    .redacted(reason: .placeholder)
            }
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .cornerRadius(cornerRadius)
    }
}
