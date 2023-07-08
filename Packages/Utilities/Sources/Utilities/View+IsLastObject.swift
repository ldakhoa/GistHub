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
}
