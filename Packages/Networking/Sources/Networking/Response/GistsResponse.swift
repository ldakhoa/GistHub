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

    init(data: GistsQuery.Data) {
        let pageInfo = data.viewer.gists.pageInfo
        cursor = pageInfo.endCursor ?? ""
        hasNextPage = pageInfo.hasNextPage

        let gistsData = data.viewer.gists.edges ?? []
        gists = gistsData.compactMap { edge in
            let gist = edge?.node
            return gist?.toGist()
        }
    }
}
