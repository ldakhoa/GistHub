//
//  View+OnReceive.swift
//  GistHub
//
//  Created by Khoa Le on 05/01/2023.
//

import SwiftUI

extension View {
    func onReceive(
        _ name: Notification.Name,
        center: NotificationCenter = .default,
        object: AnyObject? = nil,
        perform action: @escaping (Notification) -> Void
    ) -> some View {
        onReceive(
            center.publisher(for: name, object: object),
            perform: action
        )
    }
}
