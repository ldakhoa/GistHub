import SwiftUI
// import Inject
import DesignSystem
import Networking
import Editor

public struct ReportABugView: View {
//    @ObserveInjection private var inject
    @Environment(\.dismiss) private var dismiss

    @State private var showConfirmDismissAlert: Bool = false
    @State private var showErrorToast: Bool = false
    @State private var showSuccessToast: Bool = false
    @State private var showLoadingToast: Bool = false
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var networkError: String = ""
    private let client: GistHubAPIClient = DefaultGistHubAPIClient()

    public init() {}

    // MARK: - View

    public var body: some View {
        NavigationStack {
            Form {
                Section("title") {
                    TextField("Required", text: $title)
                }

                Section("leave a comment") {
                    EditorViewRepresentable(
                        style: .issue,
                        content: $content,
                        language: .markdown
                    )
                    .tint(Colors.accent.color)
                    .frame(minHeight: 200)
                }
            }
            .navigationTitle("New Issue")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.visible, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        if !title.isEmpty || !content.isEmpty {
                            showConfirmDismissAlert.toggle()
                        } else {
                            dismiss()
                        }

                    }
                    .foregroundColor(Colors.accent.color)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Submit") {
                        Task {
                            await handleSubmit()
                        }
                    }
                    .foregroundColor(Colors.accent.color)
                    .disabled(title.isEmpty)
                }
            }
            .alert("Unsaved Changes", isPresented: $showConfirmDismissAlert) {
                Button("Go back", role: .cancel) {}
                Button("Discard", role: .destructive) {
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to discard this new issues? Your messages will be lost.")
            }
            .toastLoading(isPresenting: $showLoadingToast)
            .toastError(isPresenting: $showErrorToast, error: networkError)
            .toastSuccess(isPresenting: $showSuccessToast, title: "Created the new issue") {
                dismiss()
            }
            .interactiveDismissDisabled(!title.isEmpty || (!title.isEmpty && !content.isEmpty))
        }
//        .enableInjection()
    }

    @MainActor
    private func handleSubmit() async {
        showLoadingToast = true
        do {
            try await client.createIssue(withTitle: title, content: content)
            showSuccessToast.toggle()
        } catch {
            networkError = error.localizedDescription
            showErrorToast.toggle()
        }
        showLoadingToast = false
    }
}
