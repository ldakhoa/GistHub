// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension Objects {
  /// An account on GitHub, with one or more owners, that has repositories, members and teams.
  static let Organization = Object(
    typename: "Organization",
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
      Interfaces.MemberStatusable.self,
      Interfaces.ProfileOwner.self,
      Interfaces.Sponsorable.self,
      Interfaces.AnnouncementBanner.self
    ]
  )
}