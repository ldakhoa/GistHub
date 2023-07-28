// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import GistHubGraphQL

public class GistsFromUserQuery: GraphQLQuery {
  public static let operationName: String = "GistsFromUser"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GistsFromUser($userName: String!, $privacy: GistPrivacy, $first: Int, $after: String) { user(login: $userName) { __typename gists(privacy: $privacy, first: $first, after: $after) { __typename edges { __typename node { __typename id name description files { __typename name language { __typename name } size text } createdAt owner { __typename id login avatarUrl ... on User { name twitterUsername isSiteAdmin url bio email } } updatedAt comments { __typename totalCount } isPublic url stargazerCount } } pageInfo { __typename hasNextPage endCursor } } } }"#
    ))

  public var userName: String
  public var privacy: GraphQLNullable<GraphQLEnum<GistHubGraphQL.GistPrivacy>>
  public var first: GraphQLNullable<Int>
  public var after: GraphQLNullable<String>

  public init(
    userName: String,
    privacy: GraphQLNullable<GraphQLEnum<GistHubGraphQL.GistPrivacy>>,
    first: GraphQLNullable<Int>,
    after: GraphQLNullable<String>
  ) {
    self.userName = userName
    self.privacy = privacy
    self.first = first
    self.after = after
  }

  public var __variables: Variables? { [
    "userName": userName,
    "privacy": privacy,
    "first": first,
    "after": after
  ] }

  public struct Data: GistHubGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("user", User?.self, arguments: ["login": .variable("userName")]),
    ] }

    /// Lookup a user by login.
    public var user: User? { __data["user"] }

    /// User
    ///
    /// Parent Type: `User`
    public struct User: GistHubGraphQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("gists", Gists.self, arguments: [
          "privacy": .variable("privacy"),
          "first": .variable("first"),
          "after": .variable("after")
        ]),
      ] }

      /// A list of the Gists the user has created.
      public var gists: Gists { __data["gists"] }

      /// User.Gists
      ///
      /// Parent Type: `GistConnection`
      public struct Gists: GistHubGraphQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.GistConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("edges", [Edge?]?.self),
          .field("pageInfo", PageInfo.self),
        ] }

        /// A list of edges.
        public var edges: [Edge?]? { __data["edges"] }
        /// Information to aid in pagination.
        public var pageInfo: PageInfo { __data["pageInfo"] }

        /// User.Gists.Edge
        ///
        /// Parent Type: `GistEdge`
        public struct Edge: GistHubGraphQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.GistEdge }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("node", Node?.self),
          ] }

          /// The item at the end of the edge.
          public var node: Node? { __data["node"] }

          /// User.Gists.Edge.Node
          ///
          /// Parent Type: `Gist`
          public struct Node: GistHubGraphQL.SelectionSet {
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

            /// User.Gists.Edge.Node.File
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

              /// User.Gists.Edge.Node.File.Language
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

            /// User.Gists.Edge.Node.Owner
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

              /// User.Gists.Edge.Node.Owner.AsUser
              ///
              /// Parent Type: `User`
              public struct AsUser: GistHubGraphQL.InlineFragment {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public typealias RootEntityType = GistsFromUserQuery.Data.User.Gists.Edge.Node.Owner
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

            /// User.Gists.Edge.Node.Comments
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

        /// User.Gists.PageInfo
        ///
        /// Parent Type: `PageInfo`
        public struct PageInfo: GistHubGraphQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.PageInfo }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("hasNextPage", Bool.self),
            .field("endCursor", String?.self),
          ] }

          /// When paginating forwards, are there more items?
          public var hasNextPage: Bool { __data["hasNextPage"] }
          /// When paginating forwards, the cursor to continue.
          public var endCursor: String? { __data["endCursor"] }
        }
      }
    }
  }
}
