// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import GistHubGraphQL

public struct UserDetail: GistHubGraphQL.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    "fragment UserDetail on User { __typename url login avatarUrl name bio }"
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: ApolloAPI.ParentType { GistHubGraphQL.Objects.User }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("url", GistHubGraphQL.URI.self),
    .field("login", String.self),
    .field("avatarUrl", GistHubGraphQL.URI.self),
    .field("name", String?.self),
    .field("bio", String?.self),
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
}
