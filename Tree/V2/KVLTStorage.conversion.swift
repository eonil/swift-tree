//
//  KVLTStorage.conversion.swift
//  Tree
//
//  Created by Henry on 2019/06/27.
//  Copyright © 2019 Eonil. All rights reserved.
//

public extension PersistentOrderedMapTree {
    /// - Complexity: O(1)
    var mapTreeStorage: KVLTStorage<Key,Value> {
        return KVLTStorage<Key,Value>(impl: impl)
    }
}
public extension KVLTStorage {
    /// - Complexity: O(1)
    var persistentOrderedMapTree: PersistentOrderedMapTree<Key,Value> {
        return PersistentOrderedMapTree<Key,Value>(impl: impl)
    }
}
