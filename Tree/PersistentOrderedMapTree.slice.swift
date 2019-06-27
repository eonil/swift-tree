//
//  PersistentOrderedMapTree.slice.swift
//  Tree
//
//  Created by Henry on 2019/06/27.
//  Copyright © 2019 Eonil. All rights reserved.
//

public extension OrderedMapTreeProtocol {
    func slice(in r: Range<Subtree.Index>, in pk: Key?) -> OrderedMapSlice<Self> {
        return OrderedMapSlice(baseTree: self, parentKey: pk, selectedRange: r)
    }
}
public struct OrderedMapSlice<Base> where
Base: OrderedMapTreeProtocol {
    var baseTree: Base
    var parentKey: Base.Key?
    var selectedRange: Range<Base.Subtree.Index>
}
