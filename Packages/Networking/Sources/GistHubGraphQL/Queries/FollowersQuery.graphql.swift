// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import GistHubGraphQL

public class FollowersQuery: GraphQLQuery {
  public static let operationName: String = "Followers"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Followers($login: String!, $first: Int, $after: String) { user(login: $login) { __typename followers(first: $first, after: $after) { __typename nodes { __typename ...UserDetail } } } }"#,
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
        .field("followers", Followers.self, arguments: [
          "first": .variable("first"),
          "after": .variable("after")
        ]),
      ] }

      /// A list of users the given user is followed by.
      public var followers: Followers { __data["followers"] }

      /// User.Followers
      ///
      /// Parent Type: `FollowerConnection`
      public struct Followers: GistHubGraphQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.FollowerConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// User.Followers.Node
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
      }
    }
  }
}
