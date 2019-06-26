//
//  PersistentOrderedRootlessMapTree.values.swift
//  Tree
//
//  Created by Henry on 2019/06/26.
//  Copyright © 2019 Eonil. All rights reserved.
//

public extension PersistentOrderedRootlessMapTree {
    var values: Values {
        return Values(impl: impl)
    }
    struct Values: Collection {
        private(set) var impl: IMPL
    }
}
public extension PersistentOrderedRootlessMapTree.Values {
    typealias Index = PersistentOrderedRootlessMapTree.Index
    typealias Element = Value
    var startIndex: Index {
        return Index(impl: impl.startIndex)
    }
    var endIndex: Index {
        return Index(impl: impl.endIndex)
    }
    func index(after i: Index) -> Index {
        return Index(impl: impl.index(after: i.impl))
    }
    subscript(_ i: Index) -> Element {
        return impl[i.impl].1
    }
}
