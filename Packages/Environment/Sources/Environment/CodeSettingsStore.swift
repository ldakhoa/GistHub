//
//  CodeSettingsStore.swift
//  GistHub
//
//  Created by Khoa Le on 14/12/2022.
//

import Foundation
import Utilities

public class CodeSettingsStore: ObservableObject {
    public let settings = UserDefaults.standard

    @Published public var text: String = UserDefaults.standard.string(forKey: Key.text) ?? "" {
        didSet {
            settings.text = text
        }
    }

    @Published public var showLineNumbers: Bool = UserDefaults.standard.bool(forKey: Key.showLineNumbers) {
        didSet {
            settings.showLineNumbers = showLineNumbers
            NotificationCenter.default.post(name: .textViewShouldUpdateSettings, object: nil)
        }
    }

    @Published public var showInvisibleCharacters: Bool = UserDefaults.standard.bool(forKey: Key.showInvisibleCharacters) {
        didSet {
            settings.showInvisibleCharacters = showInvisibleCharacters
            NotificationCenter.default.post(name: .textViewShouldUpdateSettings, object: nil)
        }
    }

    @Published public var wrapLines: Bool = UserDefaults.standard.bool(forKey: Key.wrapLines) {
        didSet {
            settings.wrapLines = wrapLines
            NotificationCenter.default.post(name: .textViewShouldUpdateSettings, object: nil)
        }
    }

    @Published public var showTabs: Bool = UserDefaults.standard.bool(forKey: Key.showTabs) {
        didSet {
            settings.showTabs = showTabs
            NotificationCenter.default.post(name: .textViewShouldUpdateSettings, object: nil)
        }
    }

    @Published public var showSpaces: Bool = UserDefaults.standard.bool(forKey: Key.showSpaces) {
        didSet {
            settings.showSpaces = showSpaces
            NotificationCenter.default.post(name: .textViewShouldUpdateSettings, object: nil)
        }
    }

    @Published public var highlightSelectedLine: Bool = UserDefaults.standard.bool(forKey: Key.highlightSelectedLine) {
        didSet {
            settings.highlightSelectedLine = highlightSelectedLine
            NotificationCenter.default.post(name: .textViewShouldUpdateSettings, object: nil)
        }
    }

    @Published public var showPageGuide: Bool = UserDefaults.standard.bool(forKey: Key.showPageGuide) {
        didSet {
            settings.showPageGuide = showPageGuide
            NotificationCenter.default.post(name: .textViewShouldUpdateSettings, object: nil)
        }
    }

    @Published public var forceDarkTheme: Bool = UserDefaults.standard.bool(forKey: Key.darkTheme) {
        didSet {
            settings.forceDarkTheme = forceDarkTheme
            settings.theme = forceDarkTheme ? .tomorrowNight : .tomorrow
            NotificationCenter.default.post(name: .textViewShouldUpdateTheme, object: nil)
        }
    }
}

enum Key {
    static let text = "GistHub.text"
    static let showLineNumbers = "GistHub.showLineNumbers"
    static let showInvisibleCharacters = "GistHub.showInvisibleCharacters"
    static let showTabs = "GistHub.showTabs"
    static let showSpaces = "GistHub.showSpaces"
    static let wrapLines = "GistHub.wrapLines"
    static let highlightSelectedLine = "GistHub.highlightSelectedLine"
    static let showPageGuide = "GistHub.showPageGuide"
    static let theme = "GistHub.theme"
    static let darkTheme = "GistHub.darktheme"
}

extension UserDefaults {
    public var text: String? {
        get {
            return string(forKey: Key.text)
        }
        set {
            set(newValue, forKey: Key.text)
        }
    }
    public var showLineNumbers: Bool {
        get {
            return bool(forKey: Key.showLineNumbers)
        }
        set {
            set(newValue, forKey: Key.showLineNumbers)
        }
    }
    public var showInvisibleCharacters: Bool {
        get {
            return bool(forKey: Key.showInvisibleCharacters)
        }
        set {
            set(newValue, forKey: Key.showInvisibleCharacters)
        }
    }
    public var showTabs: Bool {
        get {
            return bool(forKey: Key.showTabs)
        }
        set {
            set(newValue, forKey: Key.showTabs)
        }
    }
    public var showSpaces: Bool {
        get {
            return bool(forKey: Key.showSpaces)
        }
        set {
            set(newValue, forKey: Key.showSpaces)
        }
    }
    public var wrapLines: Bool {
        get {
            return bool(forKey: Key.wrapLines)
        }
        set {
            set(newValue, forKey: Key.wrapLines)
        }
    }
    public var highlightSelectedLine: Bool {
        get {
            return bool(forKey: Key.highlightSelectedLine)
        }
        set {
            set(newValue, forKey: Key.highlightSelectedLine)
        }
    }
    public var showPageGuide: Bool {
        get {
            return bool(forKey: Key.showPageGuide)
        }
        set {
            set(newValue, forKey: Key.showPageGuide)
        }
    }

    public var forceDarkTheme: Bool {
        get {
            return bool(forKey: Key.darkTheme)
        }
        set {
            set(newValue, forKey: Key.darkTheme)
        }
    }

    public var theme: ThemeSetting {
        get {
            if let rawValue = string(forKey: Key.theme), let setting = ThemeSetting(rawValue: rawValue) {
                return setting
            } else {
                return .tomorrow
            }
        }
        set {
            set(newValue.rawValue, forKey: Key.theme)
        }
    }

    public func registerDefaults() {
        register(defaults: [
            Key.showLineNumbers: true,
            Key.wrapLines: false,
            Key.highlightSelectedLine: true
        ])
    }
}
