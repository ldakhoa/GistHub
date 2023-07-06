//
//  Bundle+Version.swift
//  GistHub
//
//  Created by Khoa Le on 20/12/2022.
//

import Foundation

extension Bundle {
    var versionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var buildNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }

    var prettyVersionString: String {
        let version = versionNumber ?? "Unknown"
        let build = buildNumber ?? "0"
        let format = NSLocalizedString("Version %@ (%@)", comment: "")
        return String(format: format, arguments: [version, build])
    }
}
