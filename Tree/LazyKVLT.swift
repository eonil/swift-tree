//
//  LazyKVLT.swift
//  Tree
//
//  Created by Henry on 2019/06/27.
//  Copyright © 2019 Eonil. All rights reserved.
//

public struct LazyKVLT<Base> where Base: KVLTProtocol {
    private(set) var base: Base
}
public extension LazyKVLT {
}

public struct LazyValueMappedKVLT<Base,Derived>: KVLTProtocol where
Base: KVLTProtocol {
    private(set) var base: Base
    private(set) var fx: MapValue
    typealias MapValue = (Base.Value) -> Derived
}
public extension LazyValueMappedKVLT {
    typealias Collection = List
    typealias Key = Base.Key
    typealias Value = Derived
    subscript(k: Key) -> Derived { return fx(base[k]) }
    var collection: List { return List(base: base.collection, fx: fx) }
    func collection(of pk: Base.Key?) -> List {
        return List(base: base.collection(of: pk), fx: fx)
    }
    func tree(for k: Base.Key) -> Tree {
        return Tree(base: base.tree(for: k), fx: fx)
    }
    struct List: MapTreeCollection {
        private(set) var base: Base.List
        private(set) var fx: MapValue
    }
    struct Tree: MapTree {
        private(set) var base: Base.Tree
        private(set) var fx: MapValue
    }
}
public extension LazyValueMappedKVLT.List {
    typealias Index = Base.List.Index
    typealias Tree = LazyValueMappedKVLT.Tree
    var startIndex: Index { return base.startIndex }
    var endIndex: Index { return base.endIndex }
    subscript(_ i: Index) -> Tree { return Tree(base: base[i], fx: fx) }
}
public extension LazyValueMappedKVLT.Tree {
    typealias List = LazyValueMappedKVLT.List
    typealias Key = Base.Key
    typealias Value = Derived
    var key: Key { return base.key }
    var value: Value { return fx(base.value) }
    var collection: List { return List(base: base.collection, fx: fx) }
}
