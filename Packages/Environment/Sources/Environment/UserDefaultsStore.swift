import SwiftUI
import Utilities

@MainActor
public final class UserDefaultsStore: ObservableObject {
    public static let shared: UserDefaultsStore = UserDefaultsStore()
    public let settings: UserDefaults = .standard

    @AppStorage(Keys.showLineNumbers)
    public var showLineNumbers: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .textViewShouldUpdateSettings, object: nil)
        }
    }

    @AppStorage(Keys.showInvisibleCharacters)
    public var showInvisibleCharacters: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .textViewShouldUpdateSettings, object: nil)
        }
    }

    @AppStorage(Keys.showTabs)
    public var showTabs: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .textViewShouldUpdateSettings, object: nil)
        }
    }

    @AppStorage(Keys.showSpaces)
    public var showSpaces: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .textViewShouldUpdateSettings, object: nil)
        }
    }

    @AppStorage(Keys.wrapLines)
    public var wrapLines: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .textViewShouldUpdateSettings, object: nil)
        }
    }

    @AppStorage(Keys.highlightSelectedLine)
    public var highlightSelectedLine: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .textViewShouldUpdateSettings, object: nil)
        }
    }

    @AppStorage(Keys.showPageGuide)
    public var showPageGuide: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .textViewShouldUpdateSettings, object: nil)
        }
    }

    @AppStorage(Keys.theme)
    public var theme: ThemeSetting = .gitHubLight {
        didSet {
            NotificationCenter.default.post(name: .textViewShouldUpdateTheme, object: nil)
        }
    }

    @AppStorage(Keys.darkTheme)
    public var forceDarkTheme: Bool = false {
        didSet {
            settings.theme = forceDarkTheme ? .gitHubDark : .gitHubLight
            NotificationCenter.default.post(name: .textViewShouldUpdateTheme, object: nil)
        }
    }

    @AppStorage(Keys.openExternalsLinksInSafari)
    public var openExternalsLinksInSafari: Bool = false
}

enum Keys {
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
    static let openExternalsLinksInSafari = "GistHub.openExternalsLinksInSafari"
}

extension UserDefaults {
    public var text: String? {
        get {
            return string(forKey: Keys.text)
        }
        set {
            set(newValue, forKey: Keys.text)
        }
    }
    public var showLineNumbers: Bool {
        get {
            return bool(forKey: Keys.showLineNumbers)
        }
        set {
            set(newValue, forKey: Keys.showLineNumbers)
        }
    }
    public var showInvisibleCharacters: Bool {
        get {
            return bool(forKey: Keys.showInvisibleCharacters)
        }
        set {
            set(newValue, forKey: Keys.showInvisibleCharacters)
        }
    }
    public var showTabs: Bool {
        get {
            return bool(forKey: Keys.showTabs)
        }
        set {
            set(newValue, forKey: Keys.showTabs)
        }
    }
    public var showSpaces: Bool {
        get {
            return bool(forKey: Keys.showSpaces)
        }
        set {
            set(newValue, forKey: Keys.showSpaces)
        }
    }
    public var wrapLines: Bool {
        get {
            return bool(forKey: Keys.wrapLines)
        }
        set {
            set(newValue, forKey: Keys.wrapLines)
        }
    }
    public var highlightSelectedLine: Bool {
        get {
            return bool(forKey: Keys.highlightSelectedLine)
        }
        set {
            set(newValue, forKey: Keys.highlightSelectedLine)
        }
    }
    public var showPageGuide: Bool {
        get {
            return bool(forKey: Keys.showPageGuide)
        }
        set {
            set(newValue, forKey: Keys.showPageGuide)
        }
    }

    public var forceDarkTheme: Bool {
        get {
            return bool(forKey: Keys.darkTheme)
        }
        set {
            set(newValue, forKey: Keys.darkTheme)
        }
    }

    public var theme: ThemeSetting {
        get {
            if let rawValue = string(forKey: Keys.theme), let setting = ThemeSetting(rawValue: rawValue) {
                return setting
            } else {
                return .gitHubLight
            }
        }
        set {
            set(newValue.rawValue, forKey: Keys.theme)
        }
    }

    public func registerDefaults() {
        register(defaults: [
            Keys.showLineNumbers: true,
            Keys.wrapLines: false,
            Keys.highlightSelectedLine: true
        ])
    }
}
