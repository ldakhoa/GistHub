// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class AddStarMutation: GraphQLMutation {
  public static let operationName: String = "AddStar"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation AddStar($input: AddStarInput!) {
        addStar(input: $input) {
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

  public var input: AddStarInput

  public init(input: AddStarInput) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: GistHubGraphQL.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { GistHubGraphQL.Objects.Mutation }
    public static var __selections: [Selection] { [
      .field("addStar", AddStar?.self, arguments: ["input": .variable("input")]),
    ] }

    /// Adds a star to a Starrable.
    public var addStar: AddStar? { __data["addStar"] }

    /// AddStar
    ///
    /// Parent Type: `AddStarPayload`
    public struct AddStar: GistHubGraphQL.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { GistHubGraphQL.Objects.AddStarPayload }
      public static var __selections: [Selection] { [
        .field("starrable", Starrable?.self),
      ] }

      /// The starrable.
      public var starrable: Starrable? { __data["starrable"] }

      /// AddStar.Starrable
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
