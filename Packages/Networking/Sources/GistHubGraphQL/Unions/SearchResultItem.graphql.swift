// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension Unions {
  /// The results of a search.
  static let SearchResultItem = Union(
    name: "SearchResultItem",
    possibleTypes: [
      Objects.App.self,
      Objects.Discussion.self,
      Objects.Issue.self,
      Objects.MarketplaceListing.self,
      Objects.Organization.self,
      Objects.PullRequest.self,
      Objects.Repository.self,
      Objects.User.self
    ]
  )
}