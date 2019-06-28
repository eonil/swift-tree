//
//  ListTree.map.swift
//  Tree
//
//  Created by Henry on 2019/06/28.
//  Copyright © 2019 Eonil. All rights reserved.
//

public extension ListTree {
    /// Makes a new `ListTree` with mapped values.
    func map<X>(_ fx: (Value) -> X) -> ListTree<X> {
        var t1 = ListTree<X>(value: fx(value))
        for ct in collection {
            let ct1 = ct.map(fx)
            t1.collection.append(ct1)
        }
        return t1
    }
}

