// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import GistHubGraphQL

public class RemoveStarMutation: GraphQLMutation {
  public static let operationName: String = "RemoveStar"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation RemoveStar($input: RemoveStarInput!) { removeStar(input: $input) { __typename starrable { __typename id viewerHasStarred } } }"#
    ))

  public var input: GistHubGraphQL.RemoveStarInput

  public init(input: GistHubGraphQL.RemoveStarInput) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: GistHubGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("removeStar", RemoveStar?.self, arguments: ["input": .variable("input")]),
    ] }

    /// Removes a star from a Starrable.
    public var removeStar: RemoveStar? { __data["removeStar"] }

    /// RemoveStar
    ///
    /// Parent Type: `RemoveStarPayload`
    public struct RemoveStar: GistHubGraphQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.RemoveStarPayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("starrable", Starrable?.self),
      ] }

      /// The starrable.
      public var starrable: Starrable? { __data["starrable"] }

      /// RemoveStar.Starrable
      ///
      /// Parent Type: `Starrable`
      public struct Starrable: GistHubGraphQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Interfaces.Starrable }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", GistHubGraphQL.ID.self),
          .field("viewerHasStarred", Bool.self),
        ] }

        public var id: GistHubGraphQL.ID { __data["id"] }
        /// Returns a boolean indicating whether the viewing user has starred this starrable.
        public var viewerHasStarred: Bool { __data["viewerHasStarred"] }
      }
    }
  }
}
