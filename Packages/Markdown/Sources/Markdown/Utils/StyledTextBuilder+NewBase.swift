//
//  StyledTextBuilder+NewBase.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

import UIKit
import StyledTextKit
import DesignSystem

extension StyledTextBuilder {
    static func markdownBase() -> StyledTextBuilder {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 12
        paragraphStyle.lineSpacing = 2

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Colors.MarkdownColorStyle.foreground,
            .paragraphStyle: paragraphStyle
        ]

        let style = MarkdownText.body

        return StyledTextBuilder(styledText: StyledText(
            style: style.with(attributes: attributes))
        )
    }
}
