// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// Properties by which gist connections can be ordered.
public enum GistOrderField: String, EnumType {
  /// Order gists by creation time
  case createdAt = "CREATED_AT"
  /// Order gists by update time
  case updatedAt = "UPDATED_AT"
  /// Order gists by push time
  case pushedAt = "PUSHED_AT"
}
