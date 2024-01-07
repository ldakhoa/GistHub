//
//  View+IsLastObject.swift
//  GistHub
//
//  Created by Khoa Le on 16/12/2022.
//

import SwiftUI

extension View {
    public func isLastObject<T: Codable & Equatable>(objects: [T], object: T) -> Bool {
        let objectsCount = objects.count
        if let index = objects.firstIndex(of: object) {
            if index + 1 != objectsCount {
                return false
            }
        }
        return true
    }

    /// Applies modifiers defined in a closure if a condition is met.
    /// - Parameters:
    ///   - condition: Condition that need to be met so that the closure is appleied
    ///   - modifications: Closure that outlines the modifiers that will be applied to the View should the condition evaluate to true.
    /// - Returns: The resulting View either with the modifications applied (if condition is true) or in its original state (if condition is false).
    @ViewBuilder
    public func modifyIf<Content: View>(
        _ condition: Bool,
        _ modifications: (Self) -> Content
    ) -> some View {
        if condition {
            modifications(self)
        } else {
            self
        }
    }
}
