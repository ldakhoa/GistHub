// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class RemoveStarMutation: GraphQLMutation {
  public static let operationName: String = "RemoveStar"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation RemoveStar($input: RemoveStarInput!) {
        removeStar(input: $input) {
          __typename
          starrable {
            __typename
            id
            viewerHasStarred
          }
        }
      }
      """
    ))

  public var input: RemoveStarInput

  public init(input: RemoveStarInput) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: GistHubGraphQL.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { GistHubGraphQL.Objects.Mutation }
    public static var __selections: [Selection] { [
      .field("removeStar", RemoveStar?.self, arguments: ["input": .variable("input")]),
    ] }

    /// Removes a star from a Starrable.
    public var removeStar: RemoveStar? { __data["removeStar"] }

    /// RemoveStar
    ///
    /// Parent Type: `RemoveStarPayload`
    public struct RemoveStar: GistHubGraphQL.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { GistHubGraphQL.Objects.RemoveStarPayload }
      public static var __selections: [Selection] { [
        .field("starrable", Starrable?.self),
      ] }

      /// The starrable.
      public var starrable: Starrable? { __data["starrable"] }

      /// RemoveStar.Starrable
      ///
      /// Parent Type: `Starrable`
      public struct Starrable: GistHubGraphQL.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { GistHubGraphQL.Interfaces.Starrable }
        public static var __selections: [Selection] { [
          .field("id", ID.self),
          .field("viewerHasStarred", Bool.self),
        ] }

        public var id: ID { __data["id"] }
        /// Returns a boolean indicating whether the viewing user has starred this starrable.
        public var viewerHasStarred: Bool { __data["viewerHasStarred"] }
      }
    }
  }
}
