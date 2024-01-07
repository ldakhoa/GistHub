//
//  ViewDidLoadModifier.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import SwiftUI

public struct ViewDidLoadModifier: ViewModifier {
    @State private var didLoad = false
    private let action: (() -> Void)?

    public init(perform action: (() -> Void)? = nil) {
        self.action = action
    }

    public func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }
}

public extension View {
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
}
