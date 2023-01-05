//
//  NSNotification+Name.swift
//  GistHub
//
//  Created by Khoa Le on 14/12/2022.
//

import Foundation

extension NSNotification.Name {
    static let editorTextViewTextDidChange = NSNotification.Name("editorTextViewTextDidChange")
    static let textViewShouldUpdateSettings = NSNotification.Name("textViewShouldUpdateSettings")
    static let textViewShouldUpdateTheme = NSNotification.Name("textViewShouldUpdateTheme")
    static let textViewShouldShowMarkdownPreview = NSNotification.Name("textViewShouldShowMarkdownPreview")
    static let markdownPreviewShouldReload = NSNotification.Name("markdownPreviewShouldReload")
    static let markdownDidUpdateHeight = NSNotification.Name("markdownDidUpdateHeight")
}
