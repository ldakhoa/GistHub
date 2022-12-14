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
}
