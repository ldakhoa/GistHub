import SwiftUI
import Inject
import DesignSystem
import Networking
import Editor

struct ReportABugView: View {
    @ObserveInjection private var inject
    @Environment(\.dismiss) private var dismiss

    @State private var showConfirmDismissAlert: Bool = false
    @State private var showErrorToast: Bool = false
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var networkError: String = ""
    private let client: GistHubAPIClient = DefaultGistHubAPIClient()

    // MARK: - View

    var body: some View {
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
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        if !title.isEmpty || !content.isEmpty {
                            showConfirmDismissAlert.toggle()
                        } else {
                            dismiss()
                        }

                    }
                    .foregroundColor(Colors.accent.color)
                }

                ToolbarItem(placement: .topBarTrailing) {
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
            .toastError(isPresenting: $showErrorToast, error: networkError)
            .interactiveDismissDisabled(!title.isEmpty || (!title.isEmpty && !content.isEmpty))
        }
        .enableInjection()
    }

    @MainActor
    private func handleSubmit() async {
        do {
            try await client.createIssue(withTitle: title, content: content)
        } catch {
            networkError = error.localizedDescription
            showErrorToast.toggle()
        }
    }
}
