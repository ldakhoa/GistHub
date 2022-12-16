//
//  Secrets.swift
//  GistHub
//
//  Created by Khoa Le on 16/12/2022.
//

import Foundation

enum Secrets {
    enum CI {
        static let githubId = "{GITHUBID}"
        static let githubSecret = "{GITHUBSECRET}"
    }

    enum GitHub {
        static let clientId = Secrets.environmentVariable(named: "GITHUB_CLIENT_ID") ?? CI.githubId
        static let clientSecret = Secrets.environmentVariable(named: "GITHUB_CLIENT_SECRET") ?? CI.githubSecret
    }

    private static func environmentVariable(named: String) -> String? {
        let processInfo = ProcessInfo.processInfo
        guard let value = processInfo.environment[named] else {
            print("Missing Environment Variabled : '\(named)'")
            return nil
        }
        return value
    }
}
