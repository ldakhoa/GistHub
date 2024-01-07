import DesignSystem
import SwiftUI
import Environment

struct CreateAGistListSheetview: View {
    @Environment(\.dismiss) private var dismiss
    let completion: ((Action) -> Void)?

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
                    makeCreateButton(withAction: .public)
                    makeCreateButton(withAction: .secret)
//                    makeCreateButton(withAction: .draft)
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .presentationDetents([.height(260), .height(400)])
    }

    @ViewBuilder
    @MainActor
    private func makeCreateButton(withAction action: Action) -> some View {
        Button {
            HapticManager.shared.fireHaptic(of: .buttonPress)
            completion?(action)
            dismiss()
        } label: {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text(action.title)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Colors.accent.color)
                        Text(action.description)
                            .font(.system(size: 13))
                            .foregroundColor(Colors.neutralEmphasisPlus.color)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                    }

                    Spacer()

                    Image(systemName: action.image)
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

extension CreateAGistListSheetview {
    enum Action {
        case `public`
        case secret
        case draft

        var description: String {
            switch self {
            case .public:
                return "Public gists are visible to everyone."
            case .secret:
                return "Secret gists are hidden by search engine but visible to anyone you give the URL to."
            case .draft:
                return "Draft gists are a secure way to store, manage, and collaborate on unfinished work, snippets, or ideas exclusively within the GistHub app."
            }
        }

        var title: String {
            switch self {
            case .public:
                return "Create public gist"
            case .secret:
                return "Create secret gist"
            case .draft:
                return "Create draft gist"
            }
        }

        var image: String {
            switch self {
            case .public:
                return "arrowtriangle.up.circle"
            case .secret:
                return "lock.circle"
            case .draft:
                return "doc.circle"
            }
        }
    }
}
