//
//  MarkdownAttributeHandling.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

import Foundation

enum MarkdownAttributeHandling {
    case url(URL)
    case email(String)
    case checkbox(MarkdownCheckboxModel)

    static func make(attributes: [NSAttributedString.Key: Any]?) -> MarkdownAttributeHandling? {
        guard let attributes = attributes else { return nil }
        if let urlString = attributes[MarkdownAttribute.url] as? String, let url = URL(string: urlString) {
            return .url(url)
        } else if let emailString = attributes[MarkdownAttribute.email] as? String {
            return .email(emailString)
        } else if let checkbox = attributes[MarkdownAttribute.checkbox] as? MarkdownCheckboxModel {
            return .checkbox(checkbox)
        }

        return nil
    }
}
