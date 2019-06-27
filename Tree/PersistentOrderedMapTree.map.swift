//
//  PersistentOrderedMapTree.map.swift
//  Tree
//
//  Created by Henry on 2019/06/26.
//  Copyright © 2019 Eonil. All rights reserved.
//

public extension PersistentOrderedMapTree {
    /// Returns a new tree with mapped values.
    func mapValues<X>(_ fx: (Value) -> X) -> PersistentOrderedMapTree<Key,X>  {
        return PersistentOrderedMapTree<Key,X>(impl: impl.mapValues(fx))
    }
}
