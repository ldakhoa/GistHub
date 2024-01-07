import SwiftUI
import DesignSystem
import Environment

public struct DraftGistListsView: View {
    @StateObject private var viewModel: DraftGistListsViewModel = DraftGistListsViewModel()
    @EnvironmentObject private var currentAccount: CurrentAccount

    public init() {}

    public var body: some View {
        Text("Hi")
            .onAppear {
                Task {
                    await viewModel.test(accountName: currentAccount.user?.login ?? "ghost")
                }
            }
    }
}

@MainActor
final class DraftGistListsViewModel: ObservableObject {
    func test(accountName: String) async {
        let fileIOController: GistFileIOController = GistFileIOController(accountName: accountName)
        await fileIOController.createUserDirectoryIfNeeded()
    }
}

actor GistFileIOController {
    private let manager: FileManager = .default
    private let accountName: String

    init(accountName: String) {
        self.accountName = accountName
    }

    private lazy var appDirectionPath: URL? = {
        if let documentPath = manager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let appDirPath = documentPath.appendingPathComponent("GistHub", isDirectory: true)
            return appDirPath
        }
        return nil
    }()

    private lazy var accountDirectionPath: URL? = {
        appDirectionPath?.appendingPathComponent(accountName, isDirectory: true)
    }()

    func createUserDirectoryIfNeeded() async {
        guard let appDirectionPath, let accountDirectionPath else { return }
        do {
            if !manager.fileExists(atPath: appDirectionPath.relativePath) {
                try manager.createDirectory(at: appDirectionPath, withIntermediateDirectories: false)
                try manager.createDirectory(at: accountDirectionPath, withIntermediateDirectories: false)

                print("Created account dir \(accountDirectionPath)")
            }
        } catch {
        }
    }

    func write(from draftID: String) {

    }

}

struct DraftGistRowView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("filename.md")
                .bold()
            Text("Description will show here")
                .font(.subheadline)
                .foregroundColor(Colors.neutralEmphasisPlus.color)
                .lineLimit(0)
        }
    }
}
