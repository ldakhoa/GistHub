//
//  AppAccountsManager.swift
//  GistHub
//
//  Created by Khoa Le on 19/07/2023.
//

import SwiftUI
import OrderedCollections

// @MainActor
public class AppAccountsManager: ObservableObject {

    public static var shared = AppAccountsManager()

    @Published public var focusedAccount: AppAccount?

    public var isAuth: Bool {
        focusedAccount != nil
    }

    public var userSessions: [AppAccount] {
        _userSessions.elements
    }

    private var _userSessions: OrderedSet<AppAccount> = OrderedSet()

    // TODO: Move to keychain when migration to Router is done.
    private let defaults: UserDefaults
    private let sessionKeys = "com.github.sessionmanager.shared.session"

    public init() {
        defaults = UserDefaults(suiteName: "space.khoale.gisthub") ?? .standard

        if let data = defaults.object(forKey: sessionKeys) as? Data {
            let decoder = JSONDecoder()
            do {
                let session = try decoder.decode(OrderedSet<AppAccount>.self, from: data)
                _userSessions.formUnion(session)
            } catch {
                // handle error later
                print("Failed to decode user sessions \(error.localizedDescription)")
            }
        }

        // TODO: Handle multiple account
        focusedAccount = _userSessions.first
    }

    public func focus(_ appAccount: AppAccount) {
        update(oldAppAccount: appAccount, newAppAccount: appAccount)
    }

    public func logout() {
        _userSessions.removeAll()
        save()
        focusedAccount = nil
    }

    private func update(oldAppAccount: AppAccount, newAppAccount: AppAccount) {
        _userSessions.remove(oldAppAccount)
        _userSessions.insert(newAppAccount, at: 0)

        save()

        focusedAccount = newAppAccount
    }

    private func save() {
        if _userSessions.count > 0 {
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(_userSessions)
                defaults.set(data, forKey: sessionKeys)
            } catch {
                // handle error later
                print("Failed to encode user sessions \(error.localizedDescription)")
            }
        } else {
            defaults.removeObject(forKey: sessionKeys)
        }
    }
}
