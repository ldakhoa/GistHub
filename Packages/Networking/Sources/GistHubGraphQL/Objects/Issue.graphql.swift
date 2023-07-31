// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension Objects {
  /// An Issue is a place to discuss ideas, enhancements, tasks, and bugs for a project.
  static let Issue = Object(
    typename: "Issue",
    implementedInterfaces: [
      Interfaces.Node.self,
      Interfaces.Assignable.self,
      Interfaces.Closable.self,
      Interfaces.Comment.self,
      Interfaces.Deletable.self,
      Interfaces.Updatable.self,
      Interfaces.UpdatableComment.self,
      Interfaces.Labelable.self,
      Interfaces.Lockable.self,
      Interfaces.Reactable.self,
      Interfaces.RepositoryNode.self,
      Interfaces.Subscribable.self,
      Interfaces.SubscribableThread.self,
      Interfaces.UniformResourceLocatable.self,
      Interfaces.ProjectV2Owner.self
    ]
  )
}