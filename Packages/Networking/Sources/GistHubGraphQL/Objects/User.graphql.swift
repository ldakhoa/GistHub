// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension Objects {
  /// A user is an individual's account on GitHub that owns repositories and can make new content.
  static let User = Object(
    typename: "User",
    implementedInterfaces: [
      Interfaces.Node.self,
      Interfaces.Actor.self,
      Interfaces.PackageOwner.self,
      Interfaces.ProjectOwner.self,
      Interfaces.ProjectV2Owner.self,
      Interfaces.ProjectV2Recent.self,
      Interfaces.RepositoryDiscussionAuthor.self,
      Interfaces.RepositoryDiscussionCommentAuthor.self,
      Interfaces.RepositoryOwner.self,
      Interfaces.UniformResourceLocatable.self,
      Interfaces.ProfileOwner.self,
      Interfaces.Sponsorable.self
    ]
  )
}