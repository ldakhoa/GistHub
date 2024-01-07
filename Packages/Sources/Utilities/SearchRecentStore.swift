import Foundation

public struct SearchRecentStore<Element: Codable & Hashable>: RawRepresentable, RandomAccessCollection {
    private var elements: [Element]
    private var indices: [Element: Int]
    private let maxCount: Int

    public init(maxCount: Int = 20) {
        precondition(maxCount >= 0, "maxCount must be non-negative")
        self.elements = []
        self.indices = [:]
        self.maxCount = maxCount
    }

    public init?(rawValue: String) {
        self.init(rawValue: rawValue, maxCount: 20)
    }

    public init(_ elements: [Element], maxCount: Int = 20) {
        precondition(maxCount >= 0, "maxCount must be non-negative")
        self.elements = Array(elements.prefix(maxCount)).removingDuplicates()
        self.indices = Dictionary(uniqueKeysWithValues: self.elements.enumerated().map { ($1, $0) })
        self.maxCount = maxCount
    }

    public init?(rawValue: String, maxCount: Int = 20) {
        precondition(maxCount >= 0, "maxCount must be non-negative")
        guard
            let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self.elements = Array(result.prefix(maxCount)).removingDuplicates()
        self.indices = Dictionary(uniqueKeysWithValues: self.elements.enumerated().map { ($1, $0) })
        self.maxCount = maxCount
    }

    // Custom computed property to retrieve the maximum count
    public var maximumCount: Int {
        maxCount
    }

    // Conformance to RandomAccessCollection protocol
    public typealias Index = Array<Element>.Index
    public var startIndex: Index { elements.startIndex }
    public var endIndex: Index { elements.endIndex }
    public subscript(position: Index) -> Element { elements[position] }

    public func index(after i: Index) -> Index {
        elements.index(after: i)
    }

    public func index(before i: Index) -> Index {
        elements.index(before: i)
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(elements),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }

    public mutating func insert(_ element: Element) {
        if let index = indices[element] {
            elements.remove(at: index)
        } else if elements.count >= maxCount {
            elements.removeLast()
        }
        elements.insert(element, at: 0)
        updateIndices(startingFrom: 0)
    }

    public mutating func remove(_ element: Element) {
        if let index = indices[element] {
            elements.remove(at: index)
            updateIndices(startingFrom: index)
        }
    }

    public mutating func removeAll() {
        elements.removeAll()
        indices.removeAll()
    }

    public func contains(_ element: Element) -> Bool {
        return indices[element] != nil
    }

    private mutating func updateIndices(startingFrom startIndex: Int) {
        for (i, element) in elements.enumerated().dropFirst(startIndex) {
            indices[element] = i
        }
    }

    public var isEmpty: Bool {
        elements.isEmpty
    }

    public var count: Int {
        elements.count
    }
}

extension Array where Element: Equatable {
    func removingDuplicates() -> [Element] {
        var result = [Element]()
        for element in self where !result.contains(element) {
            result.append(element)
        }
        return result
    }
}
