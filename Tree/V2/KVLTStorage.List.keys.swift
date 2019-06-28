//
//  KVLTStorage.List.keys.swift
//  Tree
//
//  Created by Henry on 2019/06/27.
//  Copyright © 2019 Eonil. All rights reserved.
//

public extension KVLTStorage.List {
    /// Collection of keys in this list.
    /// These keys are ordered as they're in `Tree.collection`.
    var keys: Keys {
        return Keys(base: self)
    }
    struct Keys: RandomAccessCollection {
        private(set) var base: KVLTStorage.List
    }
}
public extension KVLTStorage.List.Keys {
    typealias Index = Int
    typealias Element = Key
    var startIndex: Index {
        return base.startIndex
    }
    var endIndex: Index {
        return base.endIndex
    }
    subscript(_ i: Index) -> Key {
        return base[i].key
    }
}
