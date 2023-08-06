// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// Ordering options for gist connections
public struct GistOrder: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    field: GraphQLEnum<GistHubGraphQL.GistOrderField>,
    direction: GraphQLEnum<GistHubGraphQL.OrderDirection>
  ) {
    __data = InputDict([
      "field": field,
      "direction": direction
    ])
  }

  /// The field to order repositories by.
  public var field: GraphQLEnum<GistHubGraphQL.GistOrderField> {
    get { __data["field"] }
    set { __data["field"] = newValue }
  }

  /// The ordering direction.
  public var direction: GraphQLEnum<GistHubGraphQL.OrderDirection> {
    get { __data["direction"] }
    set { __data["direction"] = newValue }
  }
}
