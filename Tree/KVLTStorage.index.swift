//
//  KVLTStorage.index.swift
//  Tree
//
//  Created by Henry on 2019/06/27.
//  Copyright © 2019 Eonil. All rights reserved.
//

public extension KVLTStorage {
    struct Index: Comparable {
        var impl: IMPL.Index
    }
}
public extension KVLTStorage.Index {
    static func < (lhs: KVLTStorage.Index, rhs: KVLTStorage.Index) -> Bool {
        return lhs.impl < rhs.impl
    }
}
