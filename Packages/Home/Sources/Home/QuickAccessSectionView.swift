import SwiftUI
import DesignSystem

struct QuickAccessSectionView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Add favorite gists here for quick access anytime, without the need to search")
                .multilineTextAlignment(.center)

            Button(action: {
            }, label: {
                HStack {
                    Spacer()
                    Text("Add Quick Access")
                        .font(.callout)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding(12)
                .foregroundColor(Colors.accent.color)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Colors.buttonBorder.color)
                )
            })
        }
        .frame(maxWidth: .infinity)
    }
}
