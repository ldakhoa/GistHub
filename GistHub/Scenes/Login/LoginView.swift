//
//  LoginView.swift
//  GistHub
//
//  Created by Khoa Le on 16/12/2022.
//

import AlertToast
import SwiftUI
import Inject

struct LoginView: View {
    @ObserveInjection private var inject
    @StateObject private var viewModel = LoginViewModel()
    @State private var showErrorToast = false
    @State private var error = ""
    @State private var ghButtonLoading = false
    @State private var patButtonLoading = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
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
                    foregroundColor: Colors.ghButtonForeground
                ) {
                    viewModel.login()
                }

                makeButton(
                    title: "Sign in with Personal Token",
                    backgroundColor: Colors.tokenButtonBackground,
                    foregroundColor: Colors.tokenButtonForeground
                ) {

                }
            }
            .padding(.bottom, 32)
        }
        .onChange(of: viewModel.contentState) { contentState in
            switch contentState {
            case .idling:
                self.ghButtonLoading = false
                self.patButtonLoading = false
            case .ghLoading:
                self.ghButtonLoading = true
            case .patLoading:
                self.patButtonLoading = true
            case let .error(error):
                self.ghButtonLoading = false
                self.patButtonLoading = false
                self.showErrorToast.toggle()
                self.error = error
            }
        }
        .toast(isPresenting: $showErrorToast, duration: 2.5) {
            AlertToast(
                displayMode: .hud,
                type: .error(Colors.danger.color),
                title: error,
                style: .style(backgroundColor: Colors.errorToastBackground.color)
            )
        }
        .enableInjection()
    }

    private func makeButton(
        title: String,
        backgroundColor: UIColor,
        foregroundColor: UIColor,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack {
                if ghButtonLoading || patButtonLoading {
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