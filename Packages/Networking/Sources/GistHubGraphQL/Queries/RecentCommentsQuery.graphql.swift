// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import GistHubGraphQL

public class RecentCommentsQuery: GraphQLQuery {
  public static let operationName: String = "RecentComments"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query RecentComments($username: String!, $last: Int) { user(login: $username) { __typename gistComments(last: $last) { __typename nodes { __typename id gist { __typename name description files { __typename name } owner { __typename login avatarUrl } } body updatedAt createdAt author { __typename login } } } } }"#
    ))

  public var username: String
  public var last: GraphQLNullable<Int>

  public init(
    username: String,
    last: GraphQLNullable<Int>
  ) {
    self.username = username
    self.last = last
  }

  public var __variables: Variables? { [
    "username": username,
    "last": last
  ] }

  public struct Data: GistHubGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("user", User?.self, arguments: ["login": .variable("username")]),
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
        .field("gistComments", GistComments.self, arguments: ["last": .variable("last")]),
      ] }

      /// A list of gist comments made by this user.
      public var gistComments: GistComments { __data["gistComments"] }

      /// User.GistComments
      ///
      /// Parent Type: `GistCommentConnection`
      public struct GistComments: GistHubGraphQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.GistCommentConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// User.GistComments.Node
        ///
        /// Parent Type: `GistComment`
        public struct Node: GistHubGraphQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.GistComment }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", GistHubGraphQL.ID.self),
            .field("gist", Gist.self),
            .field("body", String.self),
            .field("updatedAt", GistHubGraphQL.DateTime.self),
            .field("createdAt", GistHubGraphQL.DateTime.self),
            .field("author", Author?.self),
          ] }

          public var id: GistHubGraphQL.ID { __data["id"] }
          /// The associated gist.
          public var gist: Gist { __data["gist"] }
          /// Identifies the comment body.
          public var body: String { __data["body"] }
          /// Identifies the date and time when the object was last updated.
          public var updatedAt: GistHubGraphQL.DateTime { __data["updatedAt"] }
          /// Identifies the date and time when the object was created.
          public var createdAt: GistHubGraphQL.DateTime { __data["createdAt"] }
          /// The actor who authored the comment.
          public var author: Author? { __data["author"] }

          /// User.GistComments.Node.Gist
          ///
          /// Parent Type: `Gist`
          public struct Gist: GistHubGraphQL.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.Gist }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("name", String.self),
              .field("description", String?.self),
              .field("files", [File?]?.self),
              .field("owner", Owner?.self),
            ] }

            /// The gist name.
            public var name: String { __data["name"] }
            /// The gist description.
            public var description: String? { __data["description"] }
            /// The files in this gist.
            public var files: [File?]? { __data["files"] }
            /// The gist owner.
            public var owner: Owner? { __data["owner"] }

            /// User.GistComments.Node.Gist.File
            ///
            /// Parent Type: `GistFile`
            public struct File: GistHubGraphQL.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.GistFile }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("name", String?.self),
              ] }

              /// The gist file name.
              public var name: String? { __data["name"] }
            }

            /// User.GistComments.Node.Gist.Owner
            ///
            /// Parent Type: `RepositoryOwner`
            public struct Owner: GistHubGraphQL.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Interfaces.RepositoryOwner }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("login", String.self),
                .field("avatarUrl", GistHubGraphQL.URI.self),
              ] }

              /// The username used to login.
              public var login: String { __data["login"] }
              /// A URL pointing to the owner's public avatar.
              public var avatarUrl: GistHubGraphQL.URI { __data["avatarUrl"] }
            }
          }

          /// User.GistComments.Node.Author
          ///
          /// Parent Type: `Actor`
          public struct Author: GistHubGraphQL.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Interfaces.Actor }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("login", String.self),
            ] }

            /// The username of the actor.
            public var login: String { __data["login"] }
          }
        }
      }
    }
  }
}
