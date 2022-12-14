//
//  GitHubSessionManager.swift
//  GistHub
//
//  Created by Khoa Le on 18/12/2022.
//

import Foundation

protocol GitHubSessionListener: AnyObject {
    func didFocus()
}

/// An object that manages user sessions.
///
/// This will support multi user sessions later
class GitHubSessionManager: NSObject {
    private let _userSessions = NSMutableOrderedSet()
    private let defaults: UserDefaults

    private let sessionKeys = "com.github.sessionmanager.shared.session"

    weak var listener: GitHubSessionListener?

    // MARK: - Initializers

    override init() {
        defaults = UserDefaults(suiteName: "space.khoale.gisthub") ?? .standard

        // Workaround why new method not works
        if let data = defaults.object(forKey: sessionKeys) as? Data,
           let session = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSOrderedSet {
            _userSessions.union(session)
        }

        super.init()
    }

    // MARK: - Public API

    var focusedUserSession: GitHubUserSession? {
        return _userSessions.firstObject as? GitHubUserSession
    }

    func focus(_ userSession: GitHubUserSession) {
        update(oldUserSession: userSession, newUserSession: userSession)
    }

    var userSessions: [GitHubUserSession] {
        return _userSessions.array as? [GitHubUserSession] ?? []
    }

    func logout() {
        _userSessions.removeAllObjects()
        save()
    }

    // MARK: - Private

    private func update(oldUserSession: GitHubUserSession, newUserSession: GitHubUserSession) {
        _userSessions.remove(oldUserSession)
        _userSessions.insert(newUserSession, at: 0)
        save()

        // Support multiple user later
        listener?.didFocus()
    }

    private func save() {
        if _userSessions.count > 0 {
            // Workaround why new method not works
            defaults.set(NSKeyedArchiver.archivedData(withRootObject: _userSessions), forKey: sessionKeys)
        } else {
            defaults.removeObject(forKey: sessionKeys)
        }
    }
}
