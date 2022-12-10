//
//  HomePage.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import SwiftUI
import Inject

struct HomePage: View {
    @ObserveInjection private var inject
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        ZStack {
            switch viewModel.contentState {
            case .loading:
                ProgressView()
            case let .content(gists):
                LazyVStack {
                    ForEach(gists) { gist in
                        Text(gist.url ?? "")
                    }
                }
            case let .error(error):
                Text(error)
                    .foregroundColor(Colors.danger.color)
            }
        }
        .navigationTitle(Text("All Gists"))
        .onLoad { fetchGists() }
        .refreshable { fetchGists() }
        .enableInjection()
    }

    private func fetchGists() {
        Task {
            await viewModel.fetchGists()
        }
    }
}
