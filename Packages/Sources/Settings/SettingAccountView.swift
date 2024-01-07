import SwiftUI
import Models
import DesignSystem
import AppAccount
import Environment

public struct SettingAccountView: View {
    @EnvironmentObject private var appAccountsManager: AppAccountsManager
    @EnvironmentObject private var currentAccount: CurrentAccount

    public init() {}

    public var body: some View {
        List {
            ForEach(appAccountsManager.userSessions) { userSession in
                HStack {
                    Text(userSession.username ?? "")
                    Spacer()
                    Image(systemName: "checkmark.circle.fill").foregroundColor(Colors.accent.color)
                }
            }
        }
        .listStyle(.grouped)
        .navigationTitle("Accounts")
    }
}
