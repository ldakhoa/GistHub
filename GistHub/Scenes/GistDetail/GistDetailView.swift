//
//  GistDetailView.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import SwiftUI

struct GistDetailView: View {
    let gist: Gist

    var body: some View {
        Text(gist.url ?? "")
    }
}
