//
//  ListTree.map.swift
//  Tree
//
//  Created by Henry on 2019/06/28.
//  Copyright © 2019 Eonil. All rights reserved.
//

public extension ListTree {
    /// Makes a new `T` instance with mapped values.
    /// This overload makes Swift compiler to prefer `ListTree`
    /// type if returning type is not been specified.
    func map<X>(_ fx: (Value) -> X) -> ListTree<X> {
        var t1 = ListTree<X>(value: fx(value))
        for ct in collection {
            let ct1 = ct.map(fx)
            t1.collection.append(ct1)
        }
        return t1
    }
    /// Makes a new `T` instance with mapped values.
    func map<T,X>(_ fx: (Value) -> X) -> T where
    T: ReplaceableListTreeProtocol,
    T.Value == X {
        var t1 = T(value: fx(value))
        for ct in collection {
            let ct1 = ct.map(fx) as T
            t1.collection.append(ct1)
        }
        return t1
    }
}

