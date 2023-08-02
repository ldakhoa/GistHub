// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import GistHubGraphQL

public class GistsFromUserQuery: GraphQLQuery {
  public static let operationName: String = "GistsFromUser"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GistsFromUser($userName: String!, $privacy: GistPrivacy, $first: Int, $after: String) { user(login: $userName) { __typename gists(privacy: $privacy, first: $first, after: $after) { __typename edges { __typename node { __typename ...GistDetails } } pageInfo { __typename hasNextPage endCursor } } } }"#,
      fragments: [GistDetails.self]
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
              .fragment(GistDetails.self),
            ] }

            public var id: GistHubGraphQL.ID { __data["id"] }
            /// The gist name.
            public var name: String { __data["name"] }
            /// The gist description.
            public var description: String? { __data["description"] }
            /// The files in this gist.
            public var files: [GistDetails.File?]? { __data["files"] }
            /// Identifies the date and time when the object was created.
            public var createdAt: GistHubGraphQL.DateTime { __data["createdAt"] }
            /// The gist owner.
            public var owner: GistDetails.Owner? { __data["owner"] }
            /// Identifies the date and time when the object was last updated.
            public var updatedAt: GistHubGraphQL.DateTime { __data["updatedAt"] }
            /// A list of comments associated with the gist
            public var comments: GistDetails.Comments { __data["comments"] }
            /// Whether the gist is public or not.
            public var isPublic: Bool { __data["isPublic"] }
            /// The HTTP URL for this Gist.
            public var url: GistHubGraphQL.URI { __data["url"] }
            /// Returns a count of how many stargazers there are on this object
            ///
            public var stargazerCount: Int { __data["stargazerCount"] }
            /// A list of forks associated with the gist
            public var forks: GistDetails.Forks { __data["forks"] }

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var gistDetails: GistDetails { _toFragment() }
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
