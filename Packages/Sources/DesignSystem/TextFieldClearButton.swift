import SwiftUI

public struct TextFieldClearButton: ViewModifier {
    private let fieldText: Binding<String>

    public init(fieldText: Binding<String>) {
        self.fieldText = fieldText
    }

    public func body(content: Content) -> some View {
        content
            .overlay(
                VStack { // Wrap the contents in VStack or any other view container
                    if !fieldText.wrappedValue.isEmpty {
                        HStack {
                            Spacer()
                            Button {
                                fieldText.wrappedValue = ""
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(UIColor.tertiaryLabel))
                            }
                            .foregroundColor(.secondary)
                            .padding(.trailing, 4)
                        }
                    }
                }
            )
    }
}

public extension View {
    func showClearButton(_ text: Binding<String>) -> some View {
        self.modifier(TextFieldClearButton(fieldText: text))
    }
}
