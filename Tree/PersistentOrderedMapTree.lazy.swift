//
//  PersistentOrderedMapTree.lazy.swift
//  Tree
//
//  Created by Henry on 2019/06/27.
//  Copyright © 2019 Eonil. All rights reserved.
//

public extension PersistentOrderedMapTree {
    var lazy: LazyOrderedMapTree<PersistentOrderedMapTree> {
        return LazyOrderedMapTree(base: self)
    }
}
