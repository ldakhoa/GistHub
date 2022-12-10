//
//  Date+AgoString.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation

extension Date {
    public func agoString(style: RelativeDateTimeFormatter.UnitsStyle = .full) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = style
        return formatter.localizedString(for: self, relativeTo: .now)
    }
}
