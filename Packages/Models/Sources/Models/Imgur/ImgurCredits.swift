//
//  ImgurCredits.swift
//
//
//  Created by Hung Dao on 17/07/2023.
//

import Foundation

public struct ImgurCredits: Codable {
    public let userLimit: Int
    public let userRemaining: Int
    public let clientLimit: Int
    public let clientRemaining: Int
    public let resetTime: Date

    public init(
        userLimit: Int = 0,
        userRemaining: Int = 0,
        clientLimit: Int = 0,
        clientRemaining: Int = 0,
        resetTime: Date = Date()
    ) {
        self.userLimit = userLimit
        self.userRemaining = userRemaining
        self.clientLimit = clientLimit
        self.clientRemaining = clientRemaining
        self.resetTime = resetTime
    }

    enum CodingKeys: String, CodingKey {
        case userLimit = "UserLimit"
        case userRemaining = "UserRemaining"
        case clientLimit = "ClientLimit"
        case clientRemaining = "ClientRemaining"
        case resetTime = "UserReset"
    }

    public var reachedLimit: Bool {
        return clientRemaining < 10 || userRemaining < 10
    }
}
