//
//  ImgurResponse.swift
//
//
//  Created by Hung Dao on 17/07/2023.
//

import Foundation

public struct ImgurResponse<T: Codable>: Codable {
    public let data: T
    public let success: Bool
    public let status: Int
}
