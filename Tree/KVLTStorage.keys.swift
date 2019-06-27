//
//  KVLTStorage.keys.swift
//  Tree
//
//  Created by Henry on 2019/06/27.
//  Copyright © 2019 Eonil. All rights reserved.
//

public extension KVLTStorage {
    var keys: Keys {
        return Keys(impl: impl)
    }
    struct Keys: Collection {
        private(set) var impl: IMPL
    }
}
public extension KVLTStorage.Keys {
    typealias Index = KVLTStorage.Index
    typealias Element = Key
    /// - Complexity: O(log(`count`))
    func contains(_ k: Key) -> Bool {
        return firstIndex(of: k) != nil
    }
    /// - Complexity: O(log(`count`))
    func firstIndex(of k: Key) -> Index? {
        guard let i = impl.firstIndex(of: k) else { return nil }
        return Index(impl: i)
    }
    var startIndex: Index {
        return Index(impl: impl.startIndex)
    }
    var endIndex: Index {
        return Index(impl: impl.endIndex)
    }
    func index(after i: Index) -> Index {
        return Index(impl: impl.index(after: i.impl))
    }
    subscript(_ i: Index) -> Key {
        return impl[i.impl].0
    }
}
