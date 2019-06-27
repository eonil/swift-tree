//
//  LazyOrderedMapTree.swift
//  Tree
//
//  Created by Henry on 2019/06/27.
//  Copyright © 2019 Eonil. All rights reserved.
//

public struct LazyOrderedMapTree<Base> where
Base: OrderedMapTreeProtocol {
    var base: Base
}
public extension OrderedMapTreeProtocol {
    func mapValues<DerivedValue>(_ fx: @escaping (Value) -> DerivedValue) -> LazyValueMappedTree<Self,DerivedValue> {
        return LazyValueMappedTree(base: self, fx: fx)
    }
}
public struct LazyValueMappedTree<Base,Value>: OrderedMapTreeProtocol where
Base: OrderedMapTreeProtocol {
    var base: Base
    var fx: (Base.Value) -> Value
}
public extension LazyValueMappedTree {
    typealias Index = Base.Index
    typealias Key = Base.Key
    typealias Element = (key: Key, value: Value)
    typealias Subtree = LazyValueMappedSubtree<Base,Value>
    var startIndex: Index {
        return base.startIndex
    }
    var endIndex: Index {
        return base.endIndex
    }
    func index(after i: Index) -> Index {
        return base.index(after: i)
    }
    subscript(_ i: Base.Index) -> Element {
        let (k,v) = base[i]
        return (k,fx(v))
    }
    subscript(_ k: Key) -> Value {
        return fx(base[k])
    }
    func subtree(for k: Key?) -> Subtree {
        return Subtree(base: base.subtree(for: k), fx: fx)
    }
}

public struct LazyValueMappedSubtree<Base,Value>: OrderedMapSubtreeProtocol where
Base: OrderedMapTreeProtocol {
    var base: Base.Subtree
    var fx: (Base.Value) -> Value
}
public extension LazyValueMappedSubtree {
    typealias Index = Int
    typealias Key = Base.Key
    typealias Element = (key: Key, value: Value)
    var startIndex: Index {
        return base.startIndex
    }
    var endIndex: Index {
        return base.endIndex
    }
    subscript(_ i: Index) -> Element {
        let (k,v) = base[i]
        return (k,fx(v))
    }
    func subtree(at i: Index) -> LazyValueMappedSubtree {
        let ss = base.subtree(at: i)
        return LazyValueMappedSubtree(base: ss, fx: fx)
    }
}
