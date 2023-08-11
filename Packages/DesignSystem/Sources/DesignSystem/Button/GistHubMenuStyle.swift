import SwiftUI

public struct GistHubMenuStyle: MenuStyle {
    private let imageSystemName: String?
    private let foregroundColor: Color
    private let backgroundColor: Color
    private let padding: CGFloat
    private let radius: CGFloat
    private let font: Font
    private let fontWeight: Font.Weight
    private let controlSize: ControlSize

    public init(
        imageName: String? = nil,
        foregroundColor: Color,
        background: Color,
        padding: CGFloat = 12.0,
        radius: CGFloat = 0.0,
        font: Font = .callout,
        fontWeight: Font.Weight = .semibold,
        controlSize: ControlSize = .regular
    ) {
        self.imageSystemName = imageName
        self.foregroundColor = foregroundColor
        self.backgroundColor = background
        self.padding = padding
        self.radius = radius
        self.font = font
        self.fontWeight = fontWeight
        self.controlSize = controlSize
    }

    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 4) {
            Menu(configuration)
            if let imageSystemName {
                Image(systemName: imageSystemName)
            }
        }
        .font(font)
        .fontWeight(fontWeight)
        .padding(padding)
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
        .cornerRadius(radius)
        .controlSize(controlSize)
    }
}
