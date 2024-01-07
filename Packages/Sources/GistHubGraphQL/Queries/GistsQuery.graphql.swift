// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import GistHubGraphQL

public class GistsQuery: GraphQLQuery {
  public static let operationName: String = "Gists"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Gists($first: Int, $after: String, $privacy: GistPrivacy, $orderBy: GistOrder) { viewer { __typename ...GistList } }"#,
      fragments: [GistList.self, GistDetails.self]
    ))

  public var first: GraphQLNullable<Int>
  public var after: GraphQLNullable<String>
  public var privacy: GraphQLNullable<GraphQLEnum<GistHubGraphQL.GistPrivacy>>
  public var orderBy: GraphQLNullable<GistHubGraphQL.GistOrder>

  public init(
    first: GraphQLNullable<Int>,
    after: GraphQLNullable<String>,
    privacy: GraphQLNullable<GraphQLEnum<GistHubGraphQL.GistPrivacy>>,
    orderBy: GraphQLNullable<GistHubGraphQL.GistOrder>
  ) {
    self.first = first
    self.after = after
    self.privacy = privacy
    self.orderBy = orderBy
  }

  public var __variables: Variables? { [
    "first": first,
    "after": after,
    "privacy": privacy,
    "orderBy": orderBy
  ] }

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
