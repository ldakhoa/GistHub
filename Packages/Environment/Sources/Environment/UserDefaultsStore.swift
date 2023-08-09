import SwiftUI
import Utilities

@MainActor
public final class UserDefaultsStore: ObservableObject {
    public static let shared: UserDefaultsStore = UserDefaultsStore()
    public let settings: UserDefaults = .standard

    @AppStorage(UserDefaultsStore.Keys.showLineNumbers)
    public var showLineNumbers: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .textViewShouldUpdateSettings, object: nil)
        }
    }

    @AppStorage(UserDefaultsStore.Keys.showInvisibleCharacters)
    public var showInvisibleCharacters: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .textViewShouldUpdateSettings, object: nil)
        }
    }

    @AppStorage(UserDefaultsStore.Keys.showTabs)
    public var showTabs: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .textViewShouldUpdateSettings, object: nil)
        }
    }

    @AppStorage(UserDefaultsStore.Keys.showSpaces)
    public var showSpaces: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .textViewShouldUpdateSettings, object: nil)
        }
    }

    @AppStorage(UserDefaultsStore.Keys.wrapLines)
    public var wrapLines: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .textViewShouldUpdateSettings, object: nil)
        }
    }

    @AppStorage(UserDefaultsStore.Keys.highlightSelectedLine)
    public var highlightSelectedLine: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .textViewShouldUpdateSettings, object: nil)
        }
    }

    @AppStorage(UserDefaultsStore.Keys.showPageGuide)
    public var showPageGuide: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .textViewShouldUpdateSettings, object: nil)
        }
    }

    @AppStorage(UserDefaultsStore.Keys.theme)
    public var theme: ThemeSetting = .gitHubLight {
        didSet {
            NotificationCenter.default.post(name: .textViewShouldUpdateTheme, object: nil)
        }
    }

    @AppStorage(UserDefaultsStore.Keys.openExternalsLinksInSafari)
    public var openExternalsLinksInSafari: Bool = false

    @AppStorage(UserDefaultsStore.Keys.recentSearchKeywords)
    public var recentSearchKeywords: [String] = ["Test", "ldakhoa", "lmvan"]
}

extension UserDefaultsStore {
    public enum Keys {
        public static let text = "GistHub.text"
        public static let showLineNumbers = "GistHub.showLineNumbers"
        public static let showInvisibleCharacters = "GistHub.showInvisibleCharacters"
        public static let showTabs = "GistHub.showTabs"
        public static let showSpaces = "GistHub.showSpaces"
        public static let wrapLines = "GistHub.wrapLines"
        public static let highlightSelectedLine = "GistHub.highlightSelectedLine"
        public static let showPageGuide = "GistHub.showPageGuide"
        public static let theme = "GistHub.theme"
        public static let openExternalsLinksInSafari = "GistHub.openExternalsLinksInSafari"
        public static let recentSearchKeywords = "Search.recentSearchKeywords"
    }

}

extension UserDefaults {
    public var text: String? {
        get {
            return string(forKey: UserDefaultsStore.Keys.text)
        }
        set {
            set(newValue, forKey: UserDefaultsStore.Keys.text)
        }
    }
    public var showLineNumbers: Bool {
        get {
            return bool(forKey: UserDefaultsStore.Keys.showLineNumbers)
        }
        set {
            set(newValue, forKey: UserDefaultsStore.Keys.showLineNumbers)
        }
    }
    public var showInvisibleCharacters: Bool {
        get {
            return bool(forKey: UserDefaultsStore.Keys.showInvisibleCharacters)
        }
        set {
            set(newValue, forKey: UserDefaultsStore.Keys.showInvisibleCharacters)
        }
    }
    public var showTabs: Bool {
        get {
            return bool(forKey: UserDefaultsStore.Keys.showTabs)
        }
        set {
            set(newValue, forKey: UserDefaultsStore.Keys.showTabs)
        }
    }
    public var showSpaces: Bool {
        get {
            return bool(forKey: UserDefaultsStore.Keys.showSpaces)
        }
        set {
            set(newValue, forKey: UserDefaultsStore.Keys.showSpaces)
        }
    }
    public var wrapLines: Bool {
        get {
            return bool(forKey: UserDefaultsStore.Keys.wrapLines)
        }
        set {
            set(newValue, forKey: UserDefaultsStore.Keys.wrapLines)
        }
    }
    public var highlightSelectedLine: Bool {
        get {
            return bool(forKey: UserDefaultsStore.Keys.highlightSelectedLine)
        }
        set {
            set(newValue, forKey: UserDefaultsStore.Keys.highlightSelectedLine)
        }
    }
    public var showPageGuide: Bool {
        get {
            return bool(forKey: UserDefaultsStore.Keys.showPageGuide)
        }
        set {
            set(newValue, forKey: UserDefaultsStore.Keys.showPageGuide)
        }
    }

    public var theme: ThemeSetting {
        get {
            if let rawValue = string(forKey: UserDefaultsStore.Keys.theme), let setting = ThemeSetting(rawValue: rawValue) {
                return setting
            } else {
                return .gitHubLight
            }
        }
        set {
            set(newValue.rawValue, forKey: UserDefaultsStore.Keys.theme)
        }
    }

    public func registerDefaults() {
        register(defaults: [
            UserDefaultsStore.Keys.showLineNumbers: true,
            UserDefaultsStore.Keys.wrapLines: false,
            UserDefaultsStore.Keys.highlightSelectedLine: true
        ])
    }
}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard
            let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
