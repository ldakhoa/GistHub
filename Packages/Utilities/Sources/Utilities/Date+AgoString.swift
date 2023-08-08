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

    public func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy, h:mm:ss a zzz"
        dateFormatter.timeZone = TimeZone.current

        return dateFormatter.string(from: self)
    }
}
