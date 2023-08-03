//
//  Fork.swift
//
//
//  Created by Hung Dao on 02/08/2023.
//

public struct Fork: Codable {
    public let totalCount: Int

    public init(totalCount: Int) {
        self.totalCount = totalCount
    }
}
