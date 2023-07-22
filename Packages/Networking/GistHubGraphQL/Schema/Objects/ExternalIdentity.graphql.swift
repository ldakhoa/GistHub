// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension Objects {
  /// An external identity provisioned by SAML SSO or SCIM. If SAML is configured on the organization, the external identity is visible to (1) organization owners, (2) organization owners' personal access tokens (classic) with read:org or admin:org scope, (3) GitHub App with an installation token with read or write access to members. If SAML is configured on the enterprise, the external identity is visible to (1) enterprise owners, (2) enterprise owners' personal access tokens (classic) with read:enterprise or admin:enterprise scope.
  static let ExternalIdentity = Object(
    typename: "ExternalIdentity",
    implementedInterfaces: [Interfaces.Node.self]
  )
}