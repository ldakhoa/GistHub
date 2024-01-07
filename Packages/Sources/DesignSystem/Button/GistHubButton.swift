import SwiftUI

public struct GistHubButton: View {
    private let imageSystemName: String?
    private let title: LocalizedStringKey?
    private let action: () -> Void
    private let foregroundColor: Color
    private let backgroundColor: Color
    private let padding: CGFloat
    private let radius: CGFloat
    private let font: Font
    private let fontWeight: Font.Weight

    public init(
        imageName: String? = nil,
        title: LocalizedStringKey? = nil,
        foregroundColor: Color,
        background: Color,
        padding: CGFloat = 12.0,
        radius: CGFloat = 0.0,
        font: Font = .callout,
        fontWeight: Font.Weight = .semibold,
        action: @escaping () -> Void
    ) {
        self.imageSystemName = imageName
        self.title = title
        self.action = action
        self.foregroundColor = foregroundColor
        self.backgroundColor = background
        self.padding = padding
        self.radius = radius
        self.font = font
        self.fontWeight = fontWeight
    }

    public var body: some View {
        Button {
            HapticManager.shared.fireHaptic(of: .buttonPress)
            action()
        } label: {
            button
                .font(font)
                .fontWeight(fontWeight)
                .padding(padding)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .cornerRadius(radius)
                .shadow(
                    color: Colors.Palette.Black.black0.dynamicColor.color.opacity(0.4),
                    radius: 8
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }

    // TODO: Support button style, image only, title only...
    @ViewBuilder
    private var button: some View {
        if let title, let imageSystemName {
            HStack(spacing: 4) {
                Image(systemName: imageSystemName)
                Text(title)
            }
        } else if let title {
            Text(title)
        } else if let imageSystemName {
            Image(systemName: imageSystemName)
        } else {
            fatalError("Required 'title' or 'imageSystemName' to use.")
        }
    }
}

private struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        configuration
            .label
            .animation(.linear(duration: 0.15), value: configuration.isPressed)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}
