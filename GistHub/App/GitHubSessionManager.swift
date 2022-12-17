//
//  GitHubSessionManager.swift
//  GistHub
//
//  Created by Khoa Le on 18/12/2022.
//

import Foundation

protocol GitHubSessionListener: AnyObject {
    func didFocus()
    func didLogout(manager: GitHubSessionManager)
}

/// An object that manages user sessions.
///
/// This will support multi user sessions later
class GitHubSessionManager: NSObject {
    private let userSessions = NSMutableOrderedSet()
    private let defaults: UserDefaults

    private let sessionKeys = "com.github.sessionmanager.shared.session"

    weak var listener: GitHubSessionListener?

    // MARK: - Initializers

    override init() {
        defaults = UserDefaults(suiteName: "space.khoale.gisthub") ?? .standard

        do {
            if let data = defaults.object(forKey: sessionKeys) as? Data,
               let session = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSOrderedSet.self, from: data) {
                userSessions.union(session)
            }
        } catch {
            print("Unarchiver error: \(error.localizedDescription)")
        }

        super.init()
    }

    // MARK: - Public API

    var focusedUserSession: GitHubUserSession? {
        return userSessions.firstObject as? GitHubUserSession
    }

    func focus(_ userSession: GitHubUserSession) {
        update(oldUserSession: userSession, newUserSession: userSession)
    }

    // MARK: - Private

    private func update(oldUserSession: GitHubUserSession, newUserSession: GitHubUserSession) {
        userSessions.remove(oldUserSession)
        userSessions.insert(newUserSession, at: 0)
        save()

        // Support multiple user later
        listener?.didFocus()
    }

    private func save() {
        if userSessions.count > 0 {
            do {
                try defaults.set(NSKeyedArchiver.archivedData(withRootObject: userSessions, requiringSecureCoding: true), forKey: sessionKeys)
            } catch {
                print("Archiver error: \(error.localizedDescription)")
            }
        } else {
            defaults.removeObject(forKey: sessionKeys)
        }
    }
}
