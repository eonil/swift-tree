//
//  PersistentOrderedRootlessMapTree.map.swift
//  Tree
//
//  Created by Henry on 2019/06/26.
//  Copyright © 2019 Eonil. All rights reserved.
//

public extension PersistentOrderedRootlessMapTree {
    /// Returns a new tree with mapped values.
    func mapValues<X>(_ fx: (Value) -> X) -> PersistentOrderedRootlessMapTree<Key,X>  {
        return PersistentOrderedRootlessMapTree<Key,X>(impl: impl.mapValues(fx))
    }
}
