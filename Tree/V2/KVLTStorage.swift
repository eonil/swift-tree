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
KVLTStorageProtocol, ReplaceableKVLTStorageProtocol where
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
    var isEmpty: Bool {
        return count == 0
    }
    var count: Int {
        return impl.count
    }
}
public extension KVLTStorage {
    /// Root collection.
    var collection: List {
        let ks = impl.subkeys(for: nil)
        return List(pk: nil, impl: impl, cachedSubkeys: ks)
    }
    struct List: RandomAccessCollection {
        var pk: Key?
        var impl: IMPL
        var cachedSubkeys: IMPL.Subkeys
    }
    struct Tree: KVLTProtocol {
        var impl: IMPL
        var k: Key
    }
}
public extension KVLTStorage {
    subscript(_ k: Key) -> Value {
        get { return impl.value(for: k) }
        set(v) { impl.setValue(v, for: k) }
    }
    func collection(of pk: Key?) -> List {
        let ks = impl.subkeys(for: pk)
        return List(pk: pk, impl: impl, cachedSubkeys: ks)
    }
    func tree(for k: Key) -> Tree {
        return Tree(impl: impl, k: k)
    }
}
public extension KVLTStorage {
    /// Optimized version of `replace` utilizing implementation details.
    mutating func replace<C>(_ r: Range<Int>, in pk: Key?, with c: C) where
    C: Swift.Collection,
    C.Element == Tree {
        impl.removeSubtrees(r, in: pk)
        for (i,t) in c.enumerated() {
            impl.insertSubtree(t.key, of: t.impl, at: r.lowerBound+i, in: pk)
        }
    }
    /// Replaces subtrees in range `r` of subtree for`pk` with new subtrees `c`.
    mutating func replace<C>(_ r: Range<Int>, in pk: Key?, with c: C) where
    C: Swift.Collection,
    C.Element: KeyValueCollectionTreeProtocol,
    C.Element.Key == Key,
    C.Element.Value == Value {
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
    C: Swift.Collection,
    C.Element == (key: Key, value: Value) {
        impl.insert(contentsOf: c.lazy.map({ (k,v) in (k,v) }), at: i, in: pk)
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
        let ck = cachedSubkeys[i]
        return Tree(impl: impl, k: ck)
    }
}
public extension KVLTStorage.Tree {
    typealias List = KVLTStorage.List
    var key: Key {
        return k
    }
    var value: Value {
        return impl.value(for: k)
    }
    var collection: List {
        let sks = impl.subkeys(for: k)
        return List(pk: k, impl: impl, cachedSubkeys: sks)
    }
}
