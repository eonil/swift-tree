//
//  KVLTStorage.swift
//  Tree
//
//  Created by Henry on 2019/06/27.
//  Copyright © 2019 Eonil. All rights reserved.
//

/// Storage for key-value list tree.
///
/// This type builds tree of list of key-value pairs.
/// You read using object-oriented interface involving `List` and `Tree`
/// types, and write on storage directly.
///
public struct KVLTStorage<Key,Value>:
MapTreeStorage, ReplaceableMapTreeStorage where
Key: Comparable {
    private(set) var impl: IMPL
    typealias IMPL = IMPLPersistentOrderedMapTree<Key,Value>
    init(impl x: IMPL) {
        impl = x
    }
    public init() {
        impl = IMPL()
    }
}
public extension KVLTStorage {
    /// Root collection.
    var collection: List {
        let ks = impl.subkeys(for: nil)
        return List(pk: nil, impl: impl, cachedSubkeys: ks)
    }
    struct List: MapTreeCollection {
        var pk: Key?
        var impl: IMPL
        var cachedSubkeys: IMPL.Subkeys
    }
    struct Tree: MapTree {
        var impl: IMPL
        var pk: Key?
        var idx: Int
    }
}
public extension KVLTStorage {
    func contains(_ k: Key) -> Bool {
        return impl.firstIndex(of: k) != nil
    }
    subscript(_ k: Key) -> Value {
        get { return impl.value(for: k) }
        set(v) { impl.setValue(v, for: k) }
    }
}
public extension KVLTStorage {
    /// Optimized version of `replace`.
    mutating func replace<C>(_ r: Range<Int>, in pk: Key?, with c: C) where
    C: Collection,
    C.Element == Tree {
        impl.removeSubtrees(r, in: pk)
        for (i,t) in c.enumerated() {
            impl.insertSubtree(t.key, of: t.impl, at: r.lowerBound+i, in: pk)
        }
    }
    /// Replaces subtrees in range `r` of subtree for`pk` with new subtrees `c`.
    mutating func replace<C>(_ r: Range<Int>, in pk: Key?, with c: C) where
    C: Collection,
    C.Element: MapTree,
    C.Element.Key == Key,
    C.Element.Value == Value,
    C.Element.Collection.Index == List.Index {
        impl.removeSubtrees(r, in: pk)
        func insertRecursively(_ t: C.Element, at i: Int, in pk: Key?) {
            impl.insert((t.key,t.value), at: i, in: pk)
            for (i1,t1) in t.collection.enumerated() {
                insertRecursively(t1, at: i1, in: t.key)
            }
        }
        for (i,t) in c.enumerated() {
            insertRecursively(t, at: r.lowerBound+i, in: pk)
        }
    }
    mutating func insert<C>(contentsOf c: C, at i: Int, in pk: Key?) where
    C: Collection,
    C.Element: MapTree,
    C.Element.Key == Key,
    C.Element.Value == Value,
    C.Element.Collection.Index == List.Index {
        replace(i..<i, in: pk, with: c)
    }
    mutating func insert<T>(_ t: T, at i: Int, in pk: Key?) where
    T: MapTree,
    T.Key == Key,
    T.Value == Value,
    T.Collection.Index == List.Index {
        replace(i..<i, in: pk, with: [t])
    }
    mutating func remove(_ subrange: Range<Int>, in pk: Key?) {
        replace(subrange, in: pk, with: EmptyCollection<Tree>())
    }
}
public extension KVLTStorage.List {
    typealias Tree = KVLTStorage.Tree
    var startIndex: Int {
        return cachedSubkeys.startIndex
    }
    var endIndex: Int {
        return cachedSubkeys.endIndex
    }
    subscript(_ i: Int) -> Tree {
        return Tree(impl: impl, pk: pk, idx: i)
    }
}
public extension KVLTStorage.Tree {
    typealias List = KVLTStorage.List
    var key: Key {
        return impl.subkeys(for: pk)[idx]
    }
    var value: Value {
        return impl.value(for: pk!)
    }
    var collection: List {
        let ks = impl.subkeys(for: key)
        return List(pk: key, impl: impl, cachedSubkeys: ks)
    }
}


