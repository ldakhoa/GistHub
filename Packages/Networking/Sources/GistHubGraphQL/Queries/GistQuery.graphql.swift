// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import GistHubGraphQL

public class GistQuery: GraphQLQuery {
  public static let operationName: String = "Gist"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Gist($gistID: String!) { viewer { __typename gist(name: $gistID) { __typename ...GistDetails } } }"#,
      fragments: [GistDetails.self]
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
  }
}
