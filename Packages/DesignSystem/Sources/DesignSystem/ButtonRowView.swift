//
//  File.swift
//  
//
//  Created by Khoa Le on 22/07/2023.
//

import SwiftUI

public struct ButtonRowView: View {
    private let title: LocalizedStringKey
    private let action: () -> Void

    public init(
        title: LocalizedStringKey,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action, label: {
            HStack {
                Text(title)
                    .foregroundColor(Colors.foreground.color)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(UIColor.tertiaryLabel))
            }
        })
    }
}

fileprivate extension Colors {
    static let foreground = UIColor(light: .black, dark: .white)
}
