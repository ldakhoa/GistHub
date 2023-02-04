//
//  View+DismissKeyboard.swift
//  GistHub
//
//  Created by Khoa Le on 24/01/2023.
//

import UIKit
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
