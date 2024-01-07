// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import GistHubGraphQL

public class IsStarredQuery: GraphQLQuery {
  public static let operationName: String = "IsStarred"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query IsStarred($gistID: String!) { viewer { __typename gist(name: $gistID) { __typename viewerHasStarred } } }"#
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
          .field("viewerHasStarred", Bool.self),
        ] }

        /// Returns a boolean indicating whether the viewing user has starred this starrable.
        public var viewerHasStarred: Bool { __data["viewerHasStarred"] }
      }
    }
  }
}
