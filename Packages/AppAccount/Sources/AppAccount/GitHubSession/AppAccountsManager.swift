//
//  AppAccountsManager.swift
//  GistHub
//
//  Created by Khoa Le on 19/07/2023.
//

import SwiftUI

@MainActor
public class AppAccountsManager: ObservableObject {
//    @AppStorage("", )
    public static var shared = AppAccountsManager()

    @Published public var focusedAccount: AppAccount?

    init() {}
}

@MainActor
public class UserPreferences: ObservableObject {
    public static let sharedDefault = "space.khoale.gisthub"
    public static let shared = UserPreferences()
}
