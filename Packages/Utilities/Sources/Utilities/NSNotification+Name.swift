//
//  NSNotification+Name.swift
//  GistHub
//
//  Created by Khoa Le on 14/12/2022.
//

import Foundation

public extension NSNotification.Name {
    static let editorTextViewTextDidChange = NSNotification.Name("editorTextViewTextDidChange")
    static let editorTextViewDidBeginEditing = NSNotification.Name("editorTextViewDidBeginEditing")
    static let textViewShouldUpdateState = NSNotification.Name("textViewShouldUpdateState")
    static let textViewShouldUpdateSettings = NSNotification.Name("textViewShouldUpdateSettings")
    static let textViewShouldUpdateTheme = NSNotification.Name("textViewShouldUpdateTheme")
    static let textViewShouldShowMarkdownPreview = NSNotification.Name("textViewShouldShowMarkdownPreview")
    static let textViewShouldShowPhotoPicker = NSNotification.Name("textViewShouldShowPhotoPicker")
    static let markdownPreviewShouldReload = NSNotification.Name("markdownPreviewShouldReload")
    static let markdownEditorViewShouldShowAlert = NSNotification.Name("markDownEditorViewShouldShowAlert")
}
