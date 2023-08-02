//
// GistsResponse.swift
//
//
//  Created by Hung Dao on 27/07/2023.
//

import OrderedCollections
import Models
import GistHubGraphQL
import Foundation

public struct GistsResponse {
    public let gists: [Gist]
    public let cursor: String
    public let hasNextPage: Bool

    init(
        gists: [Gist],
        cursor: String = "",
        hasNextPage: Bool
    ) {
        self.gists = gists
        self.cursor = cursor
        self.hasNextPage = hasNextPage
    }

    init(data: GistsQuery.Data) {
        let pageInfo = data.viewer.gists.pageInfo
        cursor = pageInfo.endCursor ?? ""
        hasNextPage = pageInfo.hasNextPage

        let gistsEdges = data.viewer.gists.edges ?? []
        gists = gistsEdges.compactMap { edge in
            edge?.node?.gistDetails.toGist()
        }
    }

    init(data: GistsFromUserQuery.Data) {
        let pageInfo = data.user?.gists.pageInfo
        cursor = pageInfo?.endCursor ?? ""
        hasNextPage = pageInfo?.hasNextPage ?? false

        let gistsEdges = data.user?.gists.edges ?? []
        gists = gistsEdges.compactMap { edge in
            edge?.node?.gistDetails.toGist()
        }
    }
}
