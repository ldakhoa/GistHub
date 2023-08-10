// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public typealias ID = String

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == GistHubGraphQL.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == GistHubGraphQL.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == GistHubGraphQL.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == GistHubGraphQL.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> Object? {
    switch typename {
    case "Query": return GistHubGraphQL.Objects.Query
    case "User": return GistHubGraphQL.Objects.User
    case "AddedToMergeQueueEvent": return GistHubGraphQL.Objects.AddedToMergeQueueEvent
    case "AddedToProjectEvent": return GistHubGraphQL.Objects.AddedToProjectEvent
    case "App": return GistHubGraphQL.Objects.App
    case "AssignedEvent": return GistHubGraphQL.Objects.AssignedEvent
    case "AutoMergeDisabledEvent": return GistHubGraphQL.Objects.AutoMergeDisabledEvent
    case "AutoMergeEnabledEvent": return GistHubGraphQL.Objects.AutoMergeEnabledEvent
    case "AutoRebaseEnabledEvent": return GistHubGraphQL.Objects.AutoRebaseEnabledEvent
    case "AutoSquashEnabledEvent": return GistHubGraphQL.Objects.AutoSquashEnabledEvent
    case "AutomaticBaseChangeFailedEvent": return GistHubGraphQL.Objects.AutomaticBaseChangeFailedEvent
    case "AutomaticBaseChangeSucceededEvent": return GistHubGraphQL.Objects.AutomaticBaseChangeSucceededEvent
    case "BaseRefChangedEvent": return GistHubGraphQL.Objects.BaseRefChangedEvent
    case "BaseRefDeletedEvent": return GistHubGraphQL.Objects.BaseRefDeletedEvent
    case "BaseRefForcePushedEvent": return GistHubGraphQL.Objects.BaseRefForcePushedEvent
    case "Blob": return GistHubGraphQL.Objects.Blob
    case "Commit": return GistHubGraphQL.Objects.Commit
    case "Discussion": return GistHubGraphQL.Objects.Discussion
    case "Issue": return GistHubGraphQL.Objects.Issue
    case "PullRequest": return GistHubGraphQL.Objects.PullRequest
    case "CommitComment": return GistHubGraphQL.Objects.CommitComment
    case "DiscussionComment": return GistHubGraphQL.Objects.DiscussionComment
    case "GistComment": return GistHubGraphQL.Objects.GistComment
    case "IssueComment": return GistHubGraphQL.Objects.IssueComment
    case "PullRequestReview": return GistHubGraphQL.Objects.PullRequestReview
    case "PullRequestReviewComment": return GistHubGraphQL.Objects.PullRequestReviewComment
    case "CommitCommentThread": return GistHubGraphQL.Objects.CommitCommentThread
    case "DependabotUpdate": return GistHubGraphQL.Objects.DependabotUpdate
    case "DiscussionCategory": return GistHubGraphQL.Objects.DiscussionCategory
    case "PinnedDiscussion": return GistHubGraphQL.Objects.PinnedDiscussion
    case "PullRequestCommitCommentThread": return GistHubGraphQL.Objects.PullRequestCommitCommentThread
    case "RepositoryVulnerabilityAlert": return GistHubGraphQL.Objects.RepositoryVulnerabilityAlert
    case "Release": return GistHubGraphQL.Objects.Release
    case "Bot": return GistHubGraphQL.Objects.Bot
    case "EnterpriseUserAccount": return GistHubGraphQL.Objects.EnterpriseUserAccount
    case "Mannequin": return GistHubGraphQL.Objects.Mannequin
    case "Organization": return GistHubGraphQL.Objects.Organization
    case "Repository": return GistHubGraphQL.Objects.Repository
    case "Gist": return GistHubGraphQL.Objects.Gist
    case "Topic": return GistHubGraphQL.Objects.Topic
    case "Team": return GistHubGraphQL.Objects.Team
    case "Enterprise": return GistHubGraphQL.Objects.Enterprise
    case "CheckRun": return GistHubGraphQL.Objects.CheckRun
    case "StatusContext": return GistHubGraphQL.Objects.StatusContext
    case "ClosedEvent": return GistHubGraphQL.Objects.ClosedEvent
    case "ConvertToDraftEvent": return GistHubGraphQL.Objects.ConvertToDraftEvent
    case "CrossReferencedEvent": return GistHubGraphQL.Objects.CrossReferencedEvent
    case "MergedEvent": return GistHubGraphQL.Objects.MergedEvent
    case "Milestone": return GistHubGraphQL.Objects.Milestone
    case "PullRequestCommit": return GistHubGraphQL.Objects.PullRequestCommit
    case "ReadyForReviewEvent": return GistHubGraphQL.Objects.ReadyForReviewEvent
    case "RepositoryTopic": return GistHubGraphQL.Objects.RepositoryTopic
    case "ReviewDismissedEvent": return GistHubGraphQL.Objects.ReviewDismissedEvent
    case "TeamDiscussion": return GistHubGraphQL.Objects.TeamDiscussion
    case "TeamDiscussionComment": return GistHubGraphQL.Objects.TeamDiscussionComment
    case "Workflow": return GistHubGraphQL.Objects.Workflow
    case "WorkflowRun": return GistHubGraphQL.Objects.WorkflowRun
    case "WorkflowRunFile": return GistHubGraphQL.Objects.WorkflowRunFile
    case "Project": return GistHubGraphQL.Objects.Project
    case "ProjectV2": return GistHubGraphQL.Objects.ProjectV2
    case "Tag": return GistHubGraphQL.Objects.Tag
    case "Tree": return GistHubGraphQL.Objects.Tree
    case "BranchProtectionRule": return GistHubGraphQL.Objects.BranchProtectionRule
    case "BypassForcePushAllowance": return GistHubGraphQL.Objects.BypassForcePushAllowance
    case "BypassPullRequestAllowance": return GistHubGraphQL.Objects.BypassPullRequestAllowance
    case "CWE": return GistHubGraphQL.Objects.CWE
    case "CheckSuite": return GistHubGraphQL.Objects.CheckSuite
    case "CodeOfConduct": return GistHubGraphQL.Objects.CodeOfConduct
    case "CommentDeletedEvent": return GistHubGraphQL.Objects.CommentDeletedEvent
    case "Comparison": return GistHubGraphQL.Objects.Comparison
    case "ConnectedEvent": return GistHubGraphQL.Objects.ConnectedEvent
    case "ConvertedNoteToIssueEvent": return GistHubGraphQL.Objects.ConvertedNoteToIssueEvent
    case "ConvertedToDiscussionEvent": return GistHubGraphQL.Objects.ConvertedToDiscussionEvent
    case "DemilestonedEvent": return GistHubGraphQL.Objects.DemilestonedEvent
    case "DeployKey": return GistHubGraphQL.Objects.DeployKey
    case "DeployedEvent": return GistHubGraphQL.Objects.DeployedEvent
    case "Deployment": return GistHubGraphQL.Objects.Deployment
    case "DeploymentEnvironmentChangedEvent": return GistHubGraphQL.Objects.DeploymentEnvironmentChangedEvent
    case "DeploymentReview": return GistHubGraphQL.Objects.DeploymentReview
    case "DeploymentStatus": return GistHubGraphQL.Objects.DeploymentStatus
    case "DisconnectedEvent": return GistHubGraphQL.Objects.DisconnectedEvent
    case "DiscussionPoll": return GistHubGraphQL.Objects.DiscussionPoll
    case "DiscussionPollOption": return GistHubGraphQL.Objects.DiscussionPollOption
    case "DraftIssue": return GistHubGraphQL.Objects.DraftIssue
    case "EnterpriseAdministratorInvitation": return GistHubGraphQL.Objects.EnterpriseAdministratorInvitation
    case "EnterpriseIdentityProvider": return GistHubGraphQL.Objects.EnterpriseIdentityProvider
    case "EnterpriseRepositoryInfo": return GistHubGraphQL.Objects.EnterpriseRepositoryInfo
    case "EnterpriseServerInstallation": return GistHubGraphQL.Objects.EnterpriseServerInstallation
    case "EnterpriseServerUserAccount": return GistHubGraphQL.Objects.EnterpriseServerUserAccount
    case "EnterpriseServerUserAccountEmail": return GistHubGraphQL.Objects.EnterpriseServerUserAccountEmail
    case "EnterpriseServerUserAccountsUpload": return GistHubGraphQL.Objects.EnterpriseServerUserAccountsUpload
    case "Environment": return GistHubGraphQL.Objects.Environment
    case "ExternalIdentity": return GistHubGraphQL.Objects.ExternalIdentity
    case "HeadRefDeletedEvent": return GistHubGraphQL.Objects.HeadRefDeletedEvent
    case "HeadRefForcePushedEvent": return GistHubGraphQL.Objects.HeadRefForcePushedEvent
    case "HeadRefRestoredEvent": return GistHubGraphQL.Objects.HeadRefRestoredEvent
    case "IpAllowListEntry": return GistHubGraphQL.Objects.IpAllowListEntry
    case "Label": return GistHubGraphQL.Objects.Label
    case "LabeledEvent": return GistHubGraphQL.Objects.LabeledEvent
    case "Language": return GistHubGraphQL.Objects.Language
    case "License": return GistHubGraphQL.Objects.License
    case "LinkedBranch": return GistHubGraphQL.Objects.LinkedBranch
    case "LockedEvent": return GistHubGraphQL.Objects.LockedEvent
    case "MarkedAsDuplicateEvent": return GistHubGraphQL.Objects.MarkedAsDuplicateEvent
    case "MarketplaceCategory": return GistHubGraphQL.Objects.MarketplaceCategory
    case "MarketplaceListing": return GistHubGraphQL.Objects.MarketplaceListing
    case "MembersCanDeleteReposClearAuditEntry": return GistHubGraphQL.Objects.MembersCanDeleteReposClearAuditEntry
    case "MembersCanDeleteReposDisableAuditEntry": return GistHubGraphQL.Objects.MembersCanDeleteReposDisableAuditEntry
    case "MembersCanDeleteReposEnableAuditEntry": return GistHubGraphQL.Objects.MembersCanDeleteReposEnableAuditEntry
    case "OauthApplicationCreateAuditEntry": return GistHubGraphQL.Objects.OauthApplicationCreateAuditEntry
    case "OrgOauthAppAccessApprovedAuditEntry": return GistHubGraphQL.Objects.OrgOauthAppAccessApprovedAuditEntry
    case "OrgOauthAppAccessBlockedAuditEntry": return GistHubGraphQL.Objects.OrgOauthAppAccessBlockedAuditEntry
    case "OrgOauthAppAccessDeniedAuditEntry": return GistHubGraphQL.Objects.OrgOauthAppAccessDeniedAuditEntry
    case "OrgOauthAppAccessRequestedAuditEntry": return GistHubGraphQL.Objects.OrgOauthAppAccessRequestedAuditEntry
    case "OrgOauthAppAccessUnblockedAuditEntry": return GistHubGraphQL.Objects.OrgOauthAppAccessUnblockedAuditEntry
    case "OrgAddBillingManagerAuditEntry": return GistHubGraphQL.Objects.OrgAddBillingManagerAuditEntry
    case "OrgAddMemberAuditEntry": return GistHubGraphQL.Objects.OrgAddMemberAuditEntry
    case "OrgBlockUserAuditEntry": return GistHubGraphQL.Objects.OrgBlockUserAuditEntry
    case "OrgConfigDisableCollaboratorsOnlyAuditEntry": return GistHubGraphQL.Objects.OrgConfigDisableCollaboratorsOnlyAuditEntry
    case "OrgConfigEnableCollaboratorsOnlyAuditEntry": return GistHubGraphQL.Objects.OrgConfigEnableCollaboratorsOnlyAuditEntry
    case "OrgCreateAuditEntry": return GistHubGraphQL.Objects.OrgCreateAuditEntry
    case "OrgDisableOauthAppRestrictionsAuditEntry": return GistHubGraphQL.Objects.OrgDisableOauthAppRestrictionsAuditEntry
    case "OrgDisableSamlAuditEntry": return GistHubGraphQL.Objects.OrgDisableSamlAuditEntry
    case "OrgDisableTwoFactorRequirementAuditEntry": return GistHubGraphQL.Objects.OrgDisableTwoFactorRequirementAuditEntry
    case "OrgEnableOauthAppRestrictionsAuditEntry": return GistHubGraphQL.Objects.OrgEnableOauthAppRestrictionsAuditEntry
    case "OrgEnableSamlAuditEntry": return GistHubGraphQL.Objects.OrgEnableSamlAuditEntry
    case "OrgEnableTwoFactorRequirementAuditEntry": return GistHubGraphQL.Objects.OrgEnableTwoFactorRequirementAuditEntry
    case "OrgInviteMemberAuditEntry": return GistHubGraphQL.Objects.OrgInviteMemberAuditEntry
    case "OrgInviteToBusinessAuditEntry": return GistHubGraphQL.Objects.OrgInviteToBusinessAuditEntry
    case "OrgRemoveBillingManagerAuditEntry": return GistHubGraphQL.Objects.OrgRemoveBillingManagerAuditEntry
    case "OrgRemoveMemberAuditEntry": return GistHubGraphQL.Objects.OrgRemoveMemberAuditEntry
    case "OrgRemoveOutsideCollaboratorAuditEntry": return GistHubGraphQL.Objects.OrgRemoveOutsideCollaboratorAuditEntry
    case "OrgRestoreMemberAuditEntry": return GistHubGraphQL.Objects.OrgRestoreMemberAuditEntry
    case "OrgRestoreMemberMembershipOrganizationAuditEntryData": return GistHubGraphQL.Objects.OrgRestoreMemberMembershipOrganizationAuditEntryData
    case "OrgUnblockUserAuditEntry": return GistHubGraphQL.Objects.OrgUnblockUserAuditEntry
    case "OrgUpdateDefaultRepositoryPermissionAuditEntry": return GistHubGraphQL.Objects.OrgUpdateDefaultRepositoryPermissionAuditEntry
    case "OrgUpdateMemberAuditEntry": return GistHubGraphQL.Objects.OrgUpdateMemberAuditEntry
    case "OrgUpdateMemberRepositoryCreationPermissionAuditEntry": return GistHubGraphQL.Objects.OrgUpdateMemberRepositoryCreationPermissionAuditEntry
    case "OrgUpdateMemberRepositoryInvitationPermissionAuditEntry": return GistHubGraphQL.Objects.OrgUpdateMemberRepositoryInvitationPermissionAuditEntry
    case "PrivateRepositoryForkingDisableAuditEntry": return GistHubGraphQL.Objects.PrivateRepositoryForkingDisableAuditEntry
    case "OrgRestoreMemberMembershipRepositoryAuditEntryData": return GistHubGraphQL.Objects.OrgRestoreMemberMembershipRepositoryAuditEntryData
    case "PrivateRepositoryForkingEnableAuditEntry": return GistHubGraphQL.Objects.PrivateRepositoryForkingEnableAuditEntry
    case "RepoAccessAuditEntry": return GistHubGraphQL.Objects.RepoAccessAuditEntry
    case "RepoAddMemberAuditEntry": return GistHubGraphQL.Objects.RepoAddMemberAuditEntry
    case "RepoAddTopicAuditEntry": return GistHubGraphQL.Objects.RepoAddTopicAuditEntry
    case "RepoRemoveTopicAuditEntry": return GistHubGraphQL.Objects.RepoRemoveTopicAuditEntry
    case "RepoArchivedAuditEntry": return GistHubGraphQL.Objects.RepoArchivedAuditEntry
    case "RepoChangeMergeSettingAuditEntry": return GistHubGraphQL.Objects.RepoChangeMergeSettingAuditEntry
    case "RepoConfigDisableAnonymousGitAccessAuditEntry": return GistHubGraphQL.Objects.RepoConfigDisableAnonymousGitAccessAuditEntry
    case "RepoConfigDisableCollaboratorsOnlyAuditEntry": return GistHubGraphQL.Objects.RepoConfigDisableCollaboratorsOnlyAuditEntry
    case "RepoConfigDisableContributorsOnlyAuditEntry": return GistHubGraphQL.Objects.RepoConfigDisableContributorsOnlyAuditEntry
    case "RepoConfigDisableSockpuppetDisallowedAuditEntry": return GistHubGraphQL.Objects.RepoConfigDisableSockpuppetDisallowedAuditEntry
    case "RepoConfigEnableAnonymousGitAccessAuditEntry": return GistHubGraphQL.Objects.RepoConfigEnableAnonymousGitAccessAuditEntry
    case "RepoConfigEnableCollaboratorsOnlyAuditEntry": return GistHubGraphQL.Objects.RepoConfigEnableCollaboratorsOnlyAuditEntry
    case "RepoConfigEnableContributorsOnlyAuditEntry": return GistHubGraphQL.Objects.RepoConfigEnableContributorsOnlyAuditEntry
    case "RepoConfigEnableSockpuppetDisallowedAuditEntry": return GistHubGraphQL.Objects.RepoConfigEnableSockpuppetDisallowedAuditEntry
    case "RepoConfigLockAnonymousGitAccessAuditEntry": return GistHubGraphQL.Objects.RepoConfigLockAnonymousGitAccessAuditEntry
    case "RepoConfigUnlockAnonymousGitAccessAuditEntry": return GistHubGraphQL.Objects.RepoConfigUnlockAnonymousGitAccessAuditEntry
    case "RepoCreateAuditEntry": return GistHubGraphQL.Objects.RepoCreateAuditEntry
    case "RepoDestroyAuditEntry": return GistHubGraphQL.Objects.RepoDestroyAuditEntry
    case "RepoRemoveMemberAuditEntry": return GistHubGraphQL.Objects.RepoRemoveMemberAuditEntry
    case "TeamAddRepositoryAuditEntry": return GistHubGraphQL.Objects.TeamAddRepositoryAuditEntry
    case "OrgRestoreMemberMembershipTeamAuditEntryData": return GistHubGraphQL.Objects.OrgRestoreMemberMembershipTeamAuditEntryData
    case "TeamAddMemberAuditEntry": return GistHubGraphQL.Objects.TeamAddMemberAuditEntry
    case "TeamChangeParentTeamAuditEntry": return GistHubGraphQL.Objects.TeamChangeParentTeamAuditEntry
    case "TeamRemoveMemberAuditEntry": return GistHubGraphQL.Objects.TeamRemoveMemberAuditEntry
    case "TeamRemoveRepositoryAuditEntry": return GistHubGraphQL.Objects.TeamRemoveRepositoryAuditEntry
    case "RepositoryVisibilityChangeDisableAuditEntry": return GistHubGraphQL.Objects.RepositoryVisibilityChangeDisableAuditEntry
    case "RepositoryVisibilityChangeEnableAuditEntry": return GistHubGraphQL.Objects.RepositoryVisibilityChangeEnableAuditEntry
    case "MentionedEvent": return GistHubGraphQL.Objects.MentionedEvent
    case "MergeQueue": return GistHubGraphQL.Objects.MergeQueue
    case "MergeQueueEntry": return GistHubGraphQL.Objects.MergeQueueEntry
    case "MigrationSource": return GistHubGraphQL.Objects.MigrationSource
    case "MilestonedEvent": return GistHubGraphQL.Objects.MilestonedEvent
    case "MovedColumnsInProjectEvent": return GistHubGraphQL.Objects.MovedColumnsInProjectEvent
    case "OIDCProvider": return GistHubGraphQL.Objects.OIDCProvider
    case "OrganizationIdentityProvider": return GistHubGraphQL.Objects.OrganizationIdentityProvider
    case "OrganizationInvitation": return GistHubGraphQL.Objects.OrganizationInvitation
    case "OrganizationMigration": return GistHubGraphQL.Objects.OrganizationMigration
    case "Package": return GistHubGraphQL.Objects.Package
    case "PackageFile": return GistHubGraphQL.Objects.PackageFile
    case "PackageTag": return GistHubGraphQL.Objects.PackageTag
    case "PackageVersion": return GistHubGraphQL.Objects.PackageVersion
    case "PinnedEvent": return GistHubGraphQL.Objects.PinnedEvent
    case "PinnedIssue": return GistHubGraphQL.Objects.PinnedIssue
    case "ProjectCard": return GistHubGraphQL.Objects.ProjectCard
    case "ProjectColumn": return GistHubGraphQL.Objects.ProjectColumn
    case "ProjectV2Field": return GistHubGraphQL.Objects.ProjectV2Field
    case "ProjectV2IterationField": return GistHubGraphQL.Objects.ProjectV2IterationField
    case "ProjectV2SingleSelectField": return GistHubGraphQL.Objects.ProjectV2SingleSelectField
    case "ProjectV2Item": return GistHubGraphQL.Objects.ProjectV2Item
    case "ProjectV2ItemFieldDateValue": return GistHubGraphQL.Objects.ProjectV2ItemFieldDateValue
    case "ProjectV2ItemFieldIterationValue": return GistHubGraphQL.Objects.ProjectV2ItemFieldIterationValue
    case "ProjectV2ItemFieldNumberValue": return GistHubGraphQL.Objects.ProjectV2ItemFieldNumberValue
    case "ProjectV2ItemFieldSingleSelectValue": return GistHubGraphQL.Objects.ProjectV2ItemFieldSingleSelectValue
    case "ProjectV2ItemFieldTextValue": return GistHubGraphQL.Objects.ProjectV2ItemFieldTextValue
    case "ProjectV2View": return GistHubGraphQL.Objects.ProjectV2View
    case "ProjectV2Workflow": return GistHubGraphQL.Objects.ProjectV2Workflow
    case "PublicKey": return GistHubGraphQL.Objects.PublicKey
    case "PullRequestReviewThread": return GistHubGraphQL.Objects.PullRequestReviewThread
    case "PullRequestThread": return GistHubGraphQL.Objects.PullRequestThread
    case "Push": return GistHubGraphQL.Objects.Push
    case "PushAllowance": return GistHubGraphQL.Objects.PushAllowance
    case "Reaction": return GistHubGraphQL.Objects.Reaction
    case "Ref": return GistHubGraphQL.Objects.Ref
    case "ReferencedEvent": return GistHubGraphQL.Objects.ReferencedEvent
    case "ReleaseAsset": return GistHubGraphQL.Objects.ReleaseAsset
    case "RemovedFromMergeQueueEvent": return GistHubGraphQL.Objects.RemovedFromMergeQueueEvent
    case "RemovedFromProjectEvent": return GistHubGraphQL.Objects.RemovedFromProjectEvent
    case "RenamedTitleEvent": return GistHubGraphQL.Objects.RenamedTitleEvent
    case "ReopenedEvent": return GistHubGraphQL.Objects.ReopenedEvent
    case "RepositoryInvitation": return GistHubGraphQL.Objects.RepositoryInvitation
    case "RepositoryMigration": return GistHubGraphQL.Objects.RepositoryMigration
    case "RepositoryRule": return GistHubGraphQL.Objects.RepositoryRule
    case "RepositoryRuleset": return GistHubGraphQL.Objects.RepositoryRuleset
    case "RepositoryRulesetBypassActor": return GistHubGraphQL.Objects.RepositoryRulesetBypassActor
    case "ReviewDismissalAllowance": return GistHubGraphQL.Objects.ReviewDismissalAllowance
    case "ReviewRequest": return GistHubGraphQL.Objects.ReviewRequest
    case "ReviewRequestRemovedEvent": return GistHubGraphQL.Objects.ReviewRequestRemovedEvent
    case "ReviewRequestedEvent": return GistHubGraphQL.Objects.ReviewRequestedEvent
    case "SavedReply": return GistHubGraphQL.Objects.SavedReply
    case "SecurityAdvisory": return GistHubGraphQL.Objects.SecurityAdvisory
    case "SponsorsActivity": return GistHubGraphQL.Objects.SponsorsActivity
    case "SponsorsListing": return GistHubGraphQL.Objects.SponsorsListing
    case "SponsorsListingFeaturedItem": return GistHubGraphQL.Objects.SponsorsListingFeaturedItem
    case "SponsorsTier": return GistHubGraphQL.Objects.SponsorsTier
    case "Sponsorship": return GistHubGraphQL.Objects.Sponsorship
    case "SponsorshipNewsletter": return GistHubGraphQL.Objects.SponsorshipNewsletter
    case "Status": return GistHubGraphQL.Objects.Status
    case "StatusCheckRollup": return GistHubGraphQL.Objects.StatusCheckRollup
    case "SubscribedEvent": return GistHubGraphQL.Objects.SubscribedEvent
    case "TransferredEvent": return GistHubGraphQL.Objects.TransferredEvent
    case "UnassignedEvent": return GistHubGraphQL.Objects.UnassignedEvent
    case "UnlabeledEvent": return GistHubGraphQL.Objects.UnlabeledEvent
    case "UnlockedEvent": return GistHubGraphQL.Objects.UnlockedEvent
    case "UnmarkedAsDuplicateEvent": return GistHubGraphQL.Objects.UnmarkedAsDuplicateEvent
    case "UnpinnedEvent": return GistHubGraphQL.Objects.UnpinnedEvent
    case "UnsubscribedEvent": return GistHubGraphQL.Objects.UnsubscribedEvent
    case "UserBlockedEvent": return GistHubGraphQL.Objects.UserBlockedEvent
    case "UserContentEdit": return GistHubGraphQL.Objects.UserContentEdit
    case "UserStatus": return GistHubGraphQL.Objects.UserStatus
    case "VerifiableDomain": return GistHubGraphQL.Objects.VerifiableDomain
    case "GistConnection": return GistHubGraphQL.Objects.GistConnection
    case "GistEdge": return GistHubGraphQL.Objects.GistEdge
    case "GistFile": return GistHubGraphQL.Objects.GistFile
    case "GistCommentConnection": return GistHubGraphQL.Objects.GistCommentConnection
    case "PageInfo": return GistHubGraphQL.Objects.PageInfo
    case "Mutation": return GistHubGraphQL.Objects.Mutation
    case "RemoveStarPayload": return GistHubGraphQL.Objects.RemoveStarPayload
    case "AddStarPayload": return GistHubGraphQL.Objects.AddStarPayload
    case "SearchResultItemConnection": return GistHubGraphQL.Objects.SearchResultItemConnection
    case "SearchResultItemEdge": return GistHubGraphQL.Objects.SearchResultItemEdge
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
