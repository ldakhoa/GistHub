import DesignSystem
import SwiftUI
import Environment

struct CreateAGistListSheetview: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .foregroundColor(UIColor.tertiaryLabel.color)
                            .frame(width: 24, height: 24)
                    }
                }
                Spacer()
            }
            .padding(.top, 10)

            VStack(alignment: .leading) {
                Text("Create a gist")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)

                VStack(spacing: 12) {
                    makeCreateButton(
                        title: "Create public gist",
                        description: "Public gists are visible to everyone.",
                        image: "arrowtriangle.up.circle"
                    ) {
                    }
                    makeCreateButton(
                        title: "Create secret gist",
                        description: "Secret gists are hidden by search engine but visible to anyone you give the URL to.",
                        image: "lock.circle"
                    ) {
                    }
                    makeCreateButton(
                        title: "Create draft gist",
                        description: "Draft gists are a secure way to store, manage, and collaborate on unfinished work, snippets, or ideas.",
                        image: "doc.circle"
                    ) {
                    }
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .presentationDetents([.height(380), .height(400)])
    }

    @ViewBuilder
    @MainActor
    private func makeCreateButton(
        title: String,
        description: String,
        image: String,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            HapticManager.shared.fireHaptic(of: .buttonPress)
            action()
        } label: {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Colors.accent.color)
                        Text(description)
                            .font(.system(size: 13))
                            .foregroundColor(Colors.neutralEmphasisPlus.color)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                    }

                    Spacer()

                    Image(systemName: image)
                        .resizable()
                        .fontWeight(.ultraLight)
                        .frame(width: 42, height: 42)
                        .foregroundColor(Colors.accent.color)
                }
            }
        }
        .padding(16)
        .background(Colors.buttonBackground.color)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Colors.buttonBorder.color)
        )
    }
}
