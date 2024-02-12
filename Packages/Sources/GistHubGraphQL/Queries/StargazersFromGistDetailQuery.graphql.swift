// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import GistHubGraphQL

public class StargazersFromGistDetailQuery: GraphQLQuery {
  public static let operationName: String = "stargazersFromGistDetail"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query stargazersFromGistDetail($gistID: String!, $first: Int, $after: String) { viewer { __typename gist(name: $gistID) { __typename id description stargazers(first: $first, after: $after) { __typename nodes { __typename avatarUrl bio name login } pageInfo { __typename hasNextPage endCursor } } } } }"#
    ))

  public var gistID: String
  public var first: GraphQLNullable<Int>
  public var after: GraphQLNullable<String>

  public init(
    gistID: String,
    first: GraphQLNullable<Int>,
    after: GraphQLNullable<String>
  ) {
    self.gistID = gistID
    self.first = first
    self.after = after
  }

  public var __variables: Variables? { [
    "gistID": gistID,
    "first": first,
    "after": after
  ] }

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
          .field("description", String?.self),
          .field("stargazers", Stargazers.self, arguments: [
            "first": .variable("first"),
            "after": .variable("after")
          ]),
        ] }

        public var id: GistHubGraphQL.ID { __data["id"] }
        /// The gist description.
        public var description: String? { __data["description"] }
        /// A list of users who have starred this starrable.
        public var stargazers: Stargazers { __data["stargazers"] }

        /// Viewer.Gist.Stargazers
        ///
        /// Parent Type: `StargazerConnection`
        public struct Stargazers: GistHubGraphQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.StargazerConnection }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("nodes", [Node?]?.self),
            .field("pageInfo", PageInfo.self),
          ] }

          /// A list of nodes.
          public var nodes: [Node?]? { __data["nodes"] }
          /// Information to aid in pagination.
          public var pageInfo: PageInfo { __data["pageInfo"] }

          /// Viewer.Gist.Stargazers.Node
          ///
          /// Parent Type: `User`
          public struct Node: GistHubGraphQL.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.User }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("avatarUrl", GistHubGraphQL.URI.self),
              .field("bio", String?.self),
              .field("name", String?.self),
              .field("login", String.self),
            ] }

            /// A URL pointing to the user's public avatar.
            public var avatarUrl: GistHubGraphQL.URI { __data["avatarUrl"] }
            /// The user's public profile bio.
            public var bio: String? { __data["bio"] }
            /// The user's public profile name.
            public var name: String? { __data["name"] }
            /// The username used to login.
            public var login: String { __data["login"] }
          }

          /// Viewer.Gist.Stargazers.PageInfo
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
}
