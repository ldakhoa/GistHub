//
//  LoginView.swift
//  GistHub
//
//  Created by Khoa Le on 16/12/2022.
//

import SwiftUI
import Inject

struct LoginView: View {
    @ObserveInjection private var inject

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
