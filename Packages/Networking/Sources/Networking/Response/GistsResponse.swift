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

    init(data: GistList.Gists) {
        let pageInfo = data.pageInfo
        cursor = pageInfo.endCursor ?? ""
        hasNextPage = pageInfo.hasNextPage

        let gistsEdges = data.edges ?? []
        gists = gistsEdges.compactMap { edge in
            edge?.node?.gistDetails.toGist()
        }
    }
}
