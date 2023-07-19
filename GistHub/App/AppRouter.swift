//
//  AppRouter.swift
//  GistHub
//
//  Created by Khoa Le on 19/07/2023.
//

import SwiftUI
import Environment
import Gist

@MainActor
extension View {
    func withAppRouter() -> some View {
        navigationDestination(for: RouterDestination.self) { destination in
            switch destination {
            case let .gistDetail(gistId):
                GistDetailView(gistId: gistId)
            }
        }
    }

    func withSheetDestinations(sheetDestinations: Binding<SheetDestination?>) -> some View {
        sheet(item: sheetDestinations) { destination in
            switch destination {
            default:
                Text("Sheet default")
            }
        }
    }
}
