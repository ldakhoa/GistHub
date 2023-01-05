//
//  StyledTextBuilder+Checkbox.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

import UIKit
import StyledTextKit

extension StyledTextBuilder {
    func addCheckbox(checked: Bool, range: NSRange, viewerCanUpdate: Bool) {
        guard let image = UIImage.checkbox(checked: checked, viewerCanUpdate: viewerCanUpdate) else {
            return
        }
        let attachment = NSTextAttachment()
        attachment.image = image
        // nudge bounds to align better with baseline text
        attachment.bounds = CGRect(x: 0, y: -2, width: image.size.width, height: image.size.height)

        guard let attachmentString = NSAttributedString(attachment: attachment).mutableCopy() as? NSMutableAttributedString else {
            return
        }
        attachmentString.addAttribute(
            MarkdownAttribute.checkbox,
            value: MarkdownCheckboxModel(checked: checked, originalMarkdownRange: range),
            range: attachmentString.string.nsrange
        )
        add(attributedText: attachmentString).add(text: " ")
    }
}

private extension UIImage {
    static func checkbox(checked: Bool, viewerCanUpdate: Bool) -> UIImage? {
        let checkedIcon = UIImage(named: checked ? "checked" : "unchecked")?
            .withTintColor(Colors.MarkdownColorStyle.accentForeground, renderingMode: .alwaysOriginal)
        let uncheckedIcon = UIImage(named: "unchecked")?
            .withTintColor(Colors.MarkdownColorStyle.accentForeground, renderingMode: .alwaysOriginal)

        let icon = checked ? checkedIcon : uncheckedIcon
        return viewerCanUpdate ?
            icon :
            icon?.withTintColor(Colors.MarkdownColorStyle.accentForeground, renderingMode: .alwaysOriginal).alpha(0.5)
    }
}
