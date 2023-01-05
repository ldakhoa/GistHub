//
//  WidthCache.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

import UIKit

final class WidthCache<KeyType: Hashable, DataType> {

    // note: not thread safe
    private var cache = [String: DataType]()

    // MARK: Public API

    func data(key: KeyType, width: CGFloat) -> DataType? {
        return cache[mergedKey(key: key, width: width)]
    }

    func set(data: DataType, key: KeyType, width: CGFloat) {
        cache[mergedKey(key: key, width: width)] = data
    }

    // MARK: Private API

    func mergedKey(key: KeyType, width: CGFloat) -> String {
        return "\(key.hashValue)\(width)"
    }

}
