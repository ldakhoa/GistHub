//
//  ScrollViewOffsetModifier.swift
//  GistHub
//
//  Created by Khoa Le on 11/12/2022.
//

import SwiftUI

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }

    typealias Value = CGPoint
}

struct ScrollViewOffsetModifier: ViewModifier {
    let coordinateSpace: String
    @Binding var offset: CGPoint

    func body(content: Content) -> some View {
        ZStack {
            content
            GeometryReader { proxy in
                let x = proxy.frame(in: .named(coordinateSpace)).minX
                let y = proxy.frame(in: .named(coordinateSpace)).minY
                Color.clear.preference(
                    key: ScrollViewOffsetPreferenceKey.self,
                    value: CGPoint(x: x * -1, y: y * -1)
                )
            }
        }
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
            offset = value
        }
    }
}

extension View {
    public func readingScrollView(
        from coordinateSpace: String,
        into binding: Binding<CGPoint>
    ) -> some View {
        modifier(ScrollViewOffsetModifier(coordinateSpace: coordinateSpace, offset: binding))
    }
}
