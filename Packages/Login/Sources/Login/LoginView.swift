//
//  LoginView.swift
//  GistHub
//
//  Created by Khoa Le on 16/12/2022.
//

import SwiftUI
import DesignSystem
import AppAccount
import Environment

public struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var showErrorToast = false
    @State private var error = ""
    @State private var ghButtonLoading = false
    @State private var patButtonLoading = false
    @State private var showLoginAlertField = false
    @State private var accessToken = ""
    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var appAccountManager: AppAccountsManager

    public init() {}

    public var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image("default")
                .resizable()
                .frame(width: 140, height: 140)
                .cornerRadius(70)

            VStack(alignment: .center, spacing: 8) {
                Text("Welcome to GistHub")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("An open source app for GitHub Gist")
            }
            .padding(.horizontal, 24)

            Spacer()

            VStack(spacing: 16) {
                makeButton(
                    title: "Sign in with GitHub",
                    backgroundColor: Colors.ghButtonBackground,
                    foregroundColor: Colors.ghButtonForeground,
                    shouldShowLoading: ghButtonLoading
                ) {
                    HapticManager.shared.fireHaptic(of: .buttonPress)
                    viewModel.login()
                }

                makeButton(
                    title: "Sign in with Personal Token",
                    backgroundColor: Colors.tokenButtonBackground,
                    foregroundColor: Colors.tokenButtonForeground,
                    shouldShowLoading: patButtonLoading
                ) {
                    HapticManager.shared.fireHaptic(of: .buttonPress)
                    showLoginAlertField.toggle()
                }
            }
            .padding(.bottom, 32)
        }
        .onAppear {
            viewModel.appAccountsManager = appAccountManager
        }
        .onChange(of: viewModel.contentState) { contentState in
            switch contentState {
            case .idling:
                self.ghButtonLoading = false
                self.patButtonLoading = false
            case .ghLoading:
                self.ghButtonLoading = true
            case let .error(error):
                self.ghButtonLoading = false
                self.patButtonLoading = false
                self.showErrorToast.toggle()
                self.error = error
            }
        }
        .onChange(of: viewModel.finishLogin) { newValue in
            if newValue { dismiss() }
        }
        .toastError(isPresenting: $showErrorToast, error: error, displayMode: .hud)
        .alert("Personal Access Token", isPresented: $showLoginAlertField) {
            SecureField("Personal Access Token", text: $accessToken)
                .font(.callout)

            Button("Login") {
                patButtonLoading = true
                let token = accessToken
                Task {
                    await viewModel.personalAccessTokenLogin(token: token)
                }
                accessToken = ""
            }

            Button("Cancel", role: .cancel) {
                accessToken = ""
            }
        } message: {
            Text("Sign in with a Personal Access Token with both gists and user scopes.")
        }
    }

    private func makeButton(
        title: String,
        backgroundColor: UIColor,
        foregroundColor: UIColor,
        shouldShowLoading: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack {
                if shouldShowLoading {
                    ProgressView()
                        .tint(foregroundColor.color)
                } else {
                    ProgressView().hidden()
                }

                Spacer()
                Text(title)
                    .bold()
                Spacer()
            }
            .padding(16)
            .background(backgroundColor.color)
            .foregroundColor(foregroundColor.color)
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Colors.buttonBorder.color)
            )
            .padding(.horizontal, 16)
        }
    }
}

fileprivate extension Colors {
    static let tokenButtonBackground = UIColor(light: Colors.Palette.Gray.gray0.light, dark: .tertiarySystemBackground)
    static let tokenButtonForeground = UIColor(light: Colors.Palette.Black.black0.light, dark: .white)
    static let ghButtonBackground = UIColor(light: .black, dark: .white)
    static let ghButtonForeground = UIColor(light: .white, dark: .black)
}
