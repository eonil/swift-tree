//
//  LazyKVLT.swift
//  Tree
//
//  Created by Henry on 2019/06/27.
//  Copyright © 2019 Eonil. All rights reserved.
//

///
/// Sealed until compiler gets stabilized.
///

public extension KVLTStorageProtocol {
    /// Gets lazy-evaluated storage.
    /// See `LazyKVLTStorage` for details.
    var lazy: LazyKVLTStorage<Self> {
        return LazyKVLTStorage<Self>(base: self)
    }
}

public struct LazyKVLTStorage<Base> where Base: KVLTStorageProtocol {
    private(set) var base: Base
}
public extension LazyKVLTStorage {
    /// Gets value-mapped storage.
    func mapValues<Derived>(_ fx: @escaping (Base.Value) -> Derived) -> LazyValueMappedKVLTStorage<Base,Derived> {
        return LazyValueMappedKVLTStorage<Base,Derived>(base: base, fx: fx)
    }
}

public struct LazyValueMappedKVLTStorage<Base,Derived>: KVLTStorageProtocol where
Base: KVLTStorageProtocol {
    private(set) var base: Base
    private(set) var fx: MapValue
    typealias MapValue = (Base.Value) -> Derived
}
public extension LazyValueMappedKVLTStorage {
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
    struct List: RandomAccessCollection {
        private(set) var base: Base.List
        private(set) var fx: MapValue
    }
    struct Tree: KVLTProtocol {
        private(set) var base: Base.Tree
        private(set) var fx: MapValue
    }
}
public extension LazyValueMappedKVLTStorage.List {
    typealias Index = Base.List.Index
    typealias Element = Tree
    typealias Tree = LazyValueMappedKVLTStorage.Tree
    var startIndex: Index { return base.startIndex }
    var endIndex: Index { return base.endIndex }
    func index(after i: Index) -> Index { return base.index(after: i) }
    func index(before i: Index) -> Index { return base.index(before: i) }
    func index(_ i: Index, offsetBy d: Int) -> Index { return base.index(i, offsetBy: d) }
    subscript(_ i: Index) -> Tree { return Tree(base: base[i], fx: fx) }
}
public extension LazyValueMappedKVLTStorage.Tree {
    typealias List = LazyValueMappedKVLTStorage.List
    typealias Key = Base.Key
    typealias Value = Derived
    typealias Collection = List
    var key: Key { return base.key }
    var value: Value { return fx(base.value) }
    var collection: List { return List(base: base.collection, fx: fx) }
}
