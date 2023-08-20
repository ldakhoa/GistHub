// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import GistHubGraphQL

public class FollowingsQuery: GraphQLQuery {
  public static let operationName: String = "Followings"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Followings($login: String!, $first: Int, $after: String) { user(login: $login) { __typename following(first: $first, after: $after) { __typename nodes { __typename ...UserDetail } pageInfo { __typename hasNextPage endCursor } } } }"#,
      fragments: [UserDetail.self]
    ))

  public var login: String
  public var first: GraphQLNullable<Int>
  public var after: GraphQLNullable<String>

  public init(
    login: String,
    first: GraphQLNullable<Int>,
    after: GraphQLNullable<String>
  ) {
    self.login = login
    self.first = first
    self.after = after
  }

  public var __variables: Variables? { [
    "login": login,
    "first": first,
    "after": after
  ] }

  public struct Data: GistHubGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("user", User?.self, arguments: ["login": .variable("login")]),
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
        .field("following", Following.self, arguments: [
          "first": .variable("first"),
          "after": .variable("after")
        ]),
      ] }

      /// A list of users the given user is following.
      public var following: Following { __data["following"] }

      /// User.Following
      ///
      /// Parent Type: `FollowingConnection`
      public struct Following: GistHubGraphQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.FollowingConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
          .field("pageInfo", PageInfo.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }
        /// Information to aid in pagination.
        public var pageInfo: PageInfo { __data["pageInfo"] }

        /// User.Following.Node
        ///
        /// Parent Type: `User`
        public struct Node: GistHubGraphQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.User }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(UserDetail.self),
          ] }

          /// The HTTP URL for this user
          public var url: GistHubGraphQL.URI { __data["url"] }
          /// The username used to login.
          public var login: String { __data["login"] }
          /// A URL pointing to the user's public avatar.
          public var avatarUrl: GistHubGraphQL.URI { __data["avatarUrl"] }
          /// The user's public profile name.
          public var name: String? { __data["name"] }
          /// The user's public profile bio.
          public var bio: String? { __data["bio"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var userDetail: UserDetail { _toFragment() }
          }
        }

        /// User.Following.PageInfo
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
