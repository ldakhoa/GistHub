//
//  String+FileExtension.swift
//  GistHub
//
//  Created by Khoa Le on 24/01/2023.
//

import Foundation

extension String {
    public func getFileExtension() -> String? {
        if let index = self.firstIndex(of: ".") {
            let language = String(self.suffix(from: index))
                .replacingOccurrences(of: ".", with: "")
            return language
        }
        return nil
    }
}
