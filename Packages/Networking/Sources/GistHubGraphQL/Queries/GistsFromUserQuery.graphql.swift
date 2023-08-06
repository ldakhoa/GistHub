// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import GistHubGraphQL

public class GistsFromUserQuery: GraphQLQuery {
  public static let operationName: String = "GistsFromUser"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GistsFromUser($userName: String!, $privacy: GistPrivacy, $first: Int, $after: String, $orderBy: GistOrder) { user(login: $userName) { __typename ...GistList } }"#,
      fragments: [GistList.self, GistDetails.self]
    ))

  public var userName: String
  public var privacy: GraphQLNullable<GraphQLEnum<GistHubGraphQL.GistPrivacy>>
  public var first: GraphQLNullable<Int>
  public var after: GraphQLNullable<String>
  public var orderBy: GraphQLNullable<GistHubGraphQL.GistOrder>

  public init(
    userName: String,
    privacy: GraphQLNullable<GraphQLEnum<GistHubGraphQL.GistPrivacy>>,
    first: GraphQLNullable<Int>,
    after: GraphQLNullable<String>,
    orderBy: GraphQLNullable<GistHubGraphQL.GistOrder>
  ) {
    self.userName = userName
    self.privacy = privacy
    self.first = first
    self.after = after
    self.orderBy = orderBy
  }

  public var __variables: Variables? { [
    "userName": userName,
    "privacy": privacy,
    "first": first,
    "after": after,
    "orderBy": orderBy
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
        .fragment(GistList.self),
      ] }

      /// A list of the Gists the user has created.
      public var gists: GistList.Gists { __data["gists"] }

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public var gistList: GistList { _toFragment() }
      }
    }
  }
}
