//
//  PlainNavigationLink.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import SwiftUI

public struct PlainNavigationLink<Label, Destination>: View where Label: View, Destination: View {
    @ViewBuilder public var destination: () -> Destination
    @ViewBuilder public var label: () -> Label

    public init(
        @ViewBuilder destination: @escaping () -> Destination,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.destination = destination
        self.label = label
    }

    public var body: some View {
        label()
            .background(
                NavigationLink(destination: destination, label: {})
                    .opacity(0)
            )
    }
}
