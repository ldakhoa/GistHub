// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import GistHubGraphQL

public class UserSearchQuery: GraphQLQuery {
  public static let operationName: String = "UserSearchQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query UserSearchQuery($username: String!, $first: Int, $after: String) { search(query: $username, type: USER, first: $first, after: $after) { __typename edges { __typename node { __typename ... on User { login name bio avatarUrl } } } pageInfo { __typename hasNextPage endCursor } } }"#
    ))

  public var username: String
  public var first: GraphQLNullable<Int>
  public var after: GraphQLNullable<String>

  public init(
    username: String,
    first: GraphQLNullable<Int>,
    after: GraphQLNullable<String>
  ) {
    self.username = username
    self.first = first
    self.after = after
  }

  public var __variables: Variables? { [
    "username": username,
    "first": first,
    "after": after
  ] }

  public struct Data: GistHubGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("search", Search.self, arguments: [
        "query": .variable("username"),
        "type": "USER",
        "first": .variable("first"),
        "after": .variable("after")
      ]),
    ] }

    /// Perform a search across resources, returning a maximum of 1,000 results.
    public var search: Search { __data["search"] }

    /// Search
    ///
    /// Parent Type: `SearchResultItemConnection`
    public struct Search: GistHubGraphQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.SearchResultItemConnection }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("edges", [Edge?]?.self),
        .field("pageInfo", PageInfo.self),
      ] }

      /// A list of edges.
      public var edges: [Edge?]? { __data["edges"] }
      /// Information to aid in pagination.
      public var pageInfo: PageInfo { __data["pageInfo"] }

      /// Search.Edge
      ///
      /// Parent Type: `SearchResultItemEdge`
      public struct Edge: GistHubGraphQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.SearchResultItemEdge }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("node", Node?.self),
        ] }

        /// The item at the end of the edge.
        public var node: Node? { __data["node"] }

        /// Search.Edge.Node
        ///
        /// Parent Type: `SearchResultItem`
        public struct Node: GistHubGraphQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Unions.SearchResultItem }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .inlineFragment(AsUser.self),
          ] }

          public var asUser: AsUser? { _asInlineFragment() }

          /// Search.Edge.Node.AsUser
          ///
          /// Parent Type: `User`
          public struct AsUser: GistHubGraphQL.InlineFragment {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public typealias RootEntityType = UserSearchQuery.Data.Search.Edge.Node
            public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.User }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("login", String.self),
              .field("name", String?.self),
              .field("bio", String?.self),
              .field("avatarUrl", GistHubGraphQL.URI.self),
            ] }

            /// The username used to login.
            public var login: String { __data["login"] }
            /// The user's public profile name.
            public var name: String? { __data["name"] }
            /// The user's public profile bio.
            public var bio: String? { __data["bio"] }
            /// A URL pointing to the user's public avatar.
            public var avatarUrl: GistHubGraphQL.URI { __data["avatarUrl"] }
          }
        }
      }

      /// Search.PageInfo
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
