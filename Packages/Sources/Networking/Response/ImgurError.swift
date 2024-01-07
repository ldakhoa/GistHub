//
//  ImgurError.swift
//  
//
//  Created by Hung Dao on 16/07/2023.
//

import Foundation

struct ImgurError: LocalizedError, Codable {
    let message: String

    public var errorDescription: String? { message }

    enum CodingKeys: String, CodingKey {
        case message = "error"
    }
}
