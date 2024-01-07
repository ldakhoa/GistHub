import SwiftUI

public struct RightChevronRowImage: View {
    public init() {}
    public var body: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 14))
            .fontWeight(.semibold)
            .foregroundColor(Color(UIColor.tertiaryLabel))
    }
}
