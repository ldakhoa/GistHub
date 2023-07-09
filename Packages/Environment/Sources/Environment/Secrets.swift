import Foundation

public enum Secrets {
    public enum CI {
        public static let githubId = Bundle.main.infoDictionary?["GITHUBID"] as! String
        public static let githubSecret = Bundle.main.infoDictionary?["GITHUBSECRET"] as! String
    }

    public enum GitHub {
        public static let clientId = Secrets.environmentVariable(named: "GITHUB_CLIENT_ID") ?? CI.githubId
        public static let clientSecret = Secrets.environmentVariable(named: "GITHUB_CLIENT_SECRET") ?? CI.githubSecret
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
