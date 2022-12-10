//
//  GistDetailView.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import SwiftUI
import Inject

struct GistDetailView: View {
    @ObserveInjection private var inject

    @StateObject private var viewModel = GistDetailViewModel()

    let gist: Gist

    var body: some View {
        VStack {
            switch viewModel.starButtonState {
            case .idling:
                EmptyView()
            case .starred:
                buildStarButton(isStarred: true)
            case .unstarred:
                buildStarButton(isStarred: false)
            }
        }
        .onAppear {
            Task {
                await viewModel.isStarred(gistID: gist.id ?? "")
            }
        }
        .enableInjection()
    }

    private func buildStarButton(isStarred: Bool) -> some View {
        Button {
            Task {
                if isStarred {
                    await viewModel.unstarGist(gistID: gist.id ?? "")
                } else {
                    await viewModel.starGist(gistID: gist.id ?? "")
                }
            }
        } label: {
            HStack {
                Spacer()
                HStack(spacing: 4) {
                    Image(isStarred ? "star-fill" : "star")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 18, height: 18)
                    Text(isStarred ? "Unstar" : "Star")
                        .font(.callout)
                        .fontWeight(.semibold)
                }
                Spacer()
            }
            .padding(12)
            .background(Colors.buttonBackground.color)
            .foregroundColor(Colors.buttonForeground.color)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Colors.buttonBorder.color)
            )
        }
    }
}
