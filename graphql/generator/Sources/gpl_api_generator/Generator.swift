import Foundation
import ArgumentParser
import ApolloCodegenLib

@main
struct GraphQLGenerator: ParsableCommand {
    static var configuration: CommandConfiguration = CommandConfiguration(abstract: "A Swift CLI to generate API from Apollo schema.")

    @Argument(help: "Use 'download' to download and update the schema. Or 'generate' to update API.")
    var action: CommandAction

    @Option(help: "GitHub Personal Access Token. This is required to download the schema.")
    var token: String?

    func run() throws {
        let parentFolder = FileFinder
            .findParentFolder()
            .parentFolderURL()
            .parentFolderURL()
            .parentFolderURL()

        let sourceRootURL = parentFolder.parentFolderURL()

        switch action {
        case .generate:
            generate(from: sourceRootURL)
        case .download:
            download(with: sourceRootURL)
        }
    }

    private func generate(from sourceRootURL: URL) {
        print("📦 Generating...")
        let input = ApolloCodegenConfiguration.FileInput(
            schemaSearchPaths: ["\(sourceRootURL)/**/**/*.graphqls"],
            operationSearchPaths: ["\(sourceRootURL)/**/**/*.graphql"]
        )

        let outputPath = sourceRootURL
            .childFolderURL(folderName: "Packages")
            .childFolderURL(folderName: "Networking")
            .childFolderURL(folderName: "Sources")
            .childFolderURL(folderName: "GistHubGraphQL")

        let output = ApolloCodegenConfiguration.FileOutput(
            schemaTypes: ApolloCodegenConfiguration.SchemaTypesFileOutput(
                path: outputPath.path,
                moduleType: .other),
            operations: .absolute(path: outputPath.path, accessModifier: .public),
            testMocks: .none
        )

        let configuration = ApolloCodegenConfiguration(
            schemaNamespace: "GistHubGraphQL",
            input: input,
            output: output
        )

        do {
            try ApolloCodegen.build(with: configuration)
            print("✅ Generated at \(outputPath.path)")
        } catch {
            print("Failed to generate: \(error.localizedDescription)")
        }
    }

    private func download(with sourceRootURL: URL) {
        guard let token else {
            print("Required '--token' to download GitHub schema.")
            return
        }

        print("🚀 Downloading...")

        do {
            let endpointURL: URL = URL(string: "https://api.github.com/graphql")!
            let outputPath = try sourceRootURL
                .childFolderURL(folderName: "graphql")
                .childFileURL(fileName: "schema.graphqls")
            let configuration = ApolloSchemaDownloadConfiguration(
                using: .introspection(endpointURL: endpointURL, outputFormat: .SDL),
                headers: [
                    .init(
                        key: "Authorization",
                        value: "bearer \(token)"
                    )
                ],
                outputPath: outputPath.path
            )
            try ApolloSchemaDownloader.fetch(configuration: configuration)
            print("✅ Downloaded schema at \(outputPath.path)")
        } catch {
            print("Failed to download: \(error.localizedDescription)")
        }
    }
}

enum CommandAction: ExpressibleByArgument {
    case generate
    case download

    public init?(argument: String) {
        switch argument.lowercased() {
        case "generate":
            self = .generate
        case "download":
            self = .download
        default:
            return nil
        }
    }
}
