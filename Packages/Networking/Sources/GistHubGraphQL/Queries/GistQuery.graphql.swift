// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import GistHubGraphQL

public class GistQuery: GraphQLQuery {
  public static let operationName: String = "Gist"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Gist($gistID: String!) { viewer { __typename gist(name: $gistID) { __typename id name description files { __typename name language { __typename name } size text } createdAt owner { __typename id login avatarUrl ... on User { name twitterUsername isSiteAdmin url bio email } } updatedAt comments { __typename totalCount } isPublic url stargazerCount } } }"#
    ))

  public var gistID: String

  public init(gistID: String) {
    self.gistID = gistID
  }

  public var __variables: Variables? { ["gistID": gistID] }

  public struct Data: GistHubGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("viewer", Viewer.self),
    ] }

    /// The currently authenticated user.
    public var viewer: Viewer { __data["viewer"] }

    /// Viewer
    ///
    /// Parent Type: `User`
    public struct Viewer: GistHubGraphQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("gist", Gist?.self, arguments: ["name": .variable("gistID")]),
      ] }

      /// Find gist by repo name.
      public var gist: Gist? { __data["gist"] }

      /// Viewer.Gist
      ///
      /// Parent Type: `Gist`
      public struct Gist: GistHubGraphQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.Gist }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", GistHubGraphQL.ID.self),
          .field("name", String.self),
          .field("description", String?.self),
          .field("files", [File?]?.self),
          .field("createdAt", GistHubGraphQL.DateTime.self),
          .field("owner", Owner?.self),
          .field("updatedAt", GistHubGraphQL.DateTime.self),
          .field("comments", Comments.self),
          .field("isPublic", Bool.self),
          .field("url", GistHubGraphQL.URI.self),
          .field("stargazerCount", Int.self),
        ] }

        public var id: GistHubGraphQL.ID { __data["id"] }
        /// The gist name.
        public var name: String { __data["name"] }
        /// The gist description.
        public var description: String? { __data["description"] }
        /// The files in this gist.
        public var files: [File?]? { __data["files"] }
        /// Identifies the date and time when the object was created.
        public var createdAt: GistHubGraphQL.DateTime { __data["createdAt"] }
        /// The gist owner.
        public var owner: Owner? { __data["owner"] }
        /// Identifies the date and time when the object was last updated.
        public var updatedAt: GistHubGraphQL.DateTime { __data["updatedAt"] }
        /// A list of comments associated with the gist
        public var comments: Comments { __data["comments"] }
        /// Whether the gist is public or not.
        public var isPublic: Bool { __data["isPublic"] }
        /// The HTTP URL for this Gist.
        public var url: GistHubGraphQL.URI { __data["url"] }
        /// Returns a count of how many stargazers there are on this object
        ///
        public var stargazerCount: Int { __data["stargazerCount"] }

        /// Viewer.Gist.File
        ///
        /// Parent Type: `GistFile`
        public struct File: GistHubGraphQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.GistFile }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("name", String?.self),
            .field("language", Language?.self),
            .field("size", Int?.self),
            .field("text", String?.self),
          ] }

          /// The gist file name.
          public var name: String? { __data["name"] }
          /// The programming language this file is written in.
          public var language: Language? { __data["language"] }
          /// The gist file size in bytes.
          public var size: Int? { __data["size"] }
          /// UTF8 text data or null if the file is binary
          public var text: String? { __data["text"] }

          /// Viewer.Gist.File.Language
          ///
          /// Parent Type: `Language`
          public struct Language: GistHubGraphQL.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.Language }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("name", String.self),
            ] }

            /// The name of the current language.
            public var name: String { __data["name"] }
          }
        }

        /// Viewer.Gist.Owner
        ///
        /// Parent Type: `RepositoryOwner`
        public struct Owner: GistHubGraphQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Interfaces.RepositoryOwner }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", GistHubGraphQL.ID.self),
            .field("login", String.self),
            .field("avatarUrl", GistHubGraphQL.URI.self),
            .inlineFragment(AsUser.self),
          ] }

          public var id: GistHubGraphQL.ID { __data["id"] }
          /// The username used to login.
          public var login: String { __data["login"] }
          /// A URL pointing to the owner's public avatar.
          public var avatarUrl: GistHubGraphQL.URI { __data["avatarUrl"] }

          public var asUser: AsUser? { _asInlineFragment() }

          /// Viewer.Gist.Owner.AsUser
          ///
          /// Parent Type: `User`
          public struct AsUser: GistHubGraphQL.InlineFragment {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public typealias RootEntityType = GistQuery.Data.Viewer.Gist.Owner
            public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.User }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("name", String?.self),
              .field("twitterUsername", String?.self),
              .field("isSiteAdmin", Bool.self),
              .field("url", GistHubGraphQL.URI.self),
              .field("bio", String?.self),
              .field("email", String.self),
            ] }

            /// The user's public profile name.
            public var name: String? { __data["name"] }
            /// The user's Twitter username.
            public var twitterUsername: String? { __data["twitterUsername"] }
            /// Whether or not this user is a site administrator.
            public var isSiteAdmin: Bool { __data["isSiteAdmin"] }
            /// The HTTP URL for this user
            public var url: GistHubGraphQL.URI { __data["url"] }
            /// The user's public profile bio.
            public var bio: String? { __data["bio"] }
            /// The user's publicly visible profile email.
            public var email: String { __data["email"] }
            public var id: GistHubGraphQL.ID { __data["id"] }
            /// The username used to login.
            public var login: String { __data["login"] }
            /// A URL pointing to the owner's public avatar.
            public var avatarUrl: GistHubGraphQL.URI { __data["avatarUrl"] }
          }
        }

        /// Viewer.Gist.Comments
        ///
        /// Parent Type: `GistCommentConnection`
        public struct Comments: GistHubGraphQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.GistCommentConnection }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("totalCount", Int.self),
          ] }

          /// Identifies the total count of items in the connection.
          public var totalCount: Int { __data["totalCount"] }
        }
      }
    }
  }
}
