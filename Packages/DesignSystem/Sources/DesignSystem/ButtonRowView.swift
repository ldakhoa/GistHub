import SwiftUI

public struct ButtonRowView: View {
    private let title: LocalizedStringKey
    private let action: () -> Void

    public init(
        title: LocalizedStringKey,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action, label: {
            HStack {
                Text(title)
                    .foregroundColor(Colors.foreground.color)
                Spacer()
                RightChevronRowImage()
            }
        })
    }
}

fileprivate extension Colors {
    static let foreground = UIColor(light: .black, dark: .white)
}
