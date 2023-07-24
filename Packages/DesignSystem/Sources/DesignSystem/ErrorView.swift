import SwiftUI

public struct ErrorView: View {
    private let title: LocalizedStringKey
    private let message: LocalizedStringKey
    private let buttonTitle: LocalizedStringKey
    private let onPress: () -> Void

    public init(
        title: LocalizedStringKey,
        message: LocalizedStringKey = "",
        buttonTitle: LocalizedStringKey = "Retry",
        onPress: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.onPress = onPress
    }

    public var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                Text(title)
                    .font(.title3)
                    .padding(.top, 16)
                Text(message)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Colors.neutralEmphasis.color)
                Button(buttonTitle) {
                    onPress()
                }
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(Colors.accent.color)
            }
            Spacer()
        }
    }
}
