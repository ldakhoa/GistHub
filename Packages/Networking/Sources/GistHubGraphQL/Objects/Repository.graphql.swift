// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension Objects {
  /// A repository contains the content for a project.
  static let Repository = Object(
    typename: "Repository",
    implementedInterfaces: [
      Interfaces.Node.self,
      Interfaces.ProjectV2Recent.self,
      Interfaces.ProjectOwner.self,
      Interfaces.PackageOwner.self,
      Interfaces.Subscribable.self,
      Interfaces.Starrable.self,
      Interfaces.UniformResourceLocatable.self,
      Interfaces.RepositoryInfo.self
    ]
  )
}