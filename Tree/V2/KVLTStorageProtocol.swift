//
//  KVLTProtocol.swift
//  Tree
//
//  Created by Henry on 2019/06/27.
//  Copyright © 2019 Eonil. All rights reserved.
//

public protocol KVLTStorageProtocol where
Key: Comparable {
    associatedtype Key where Key == Tree.Key
    associatedtype Value where Value == Tree.Value
    associatedtype List where List == Tree.SubCollection
    associatedtype Tree: KVLTProtocol
    subscript(_ k: Key) -> Value { get }
    var collection: List { get }
    func collection(of pk: Key?) -> List
    func tree(for k: Key) -> Tree
}

public protocol KVLTProtocol: KeyValueCollectionTreeProtocol where
SubCollection: RandomAccessCollection {
    associatedtype List = SubCollection
}

public protocol ReplaceableKVLTStorageProtocol: KVLTStorageProtocol {
    subscript(_ k: Key) -> Value { get set }
    /// Replaces subtrees of specified range `r` in collection of tree for `pk` with elements in `c`.
    mutating func replace<C>(_ r: Range<List.Index>, in pk: Key?, with c: C) where
    C: Swift.Collection,
    C.Index == List.Index,
    C.Element: KeyValueCollectionTreeProtocol,
    C.Element.Key == Key,
    C.Element.Value == Value,
    C.Element.SubCollection.Index == List.Index
    /// Inserts elements in `c` at index position `i` in collection of tree for `pk`.
    mutating func insert<C>(contentsOf c: C, at i: List.Index, in pk: Key?) where
    C: Swift.Collection,
    C.Element == (key: Key, value: Value)
}
/// Convenient extension methods.
public extension ReplaceableKVLTStorageProtocol {
    mutating func insert<C>(contentsOf c: C, at i: List.Index, in pk: Key?) where
        C: Swift.Collection,
        C.Index == List.Index,
        C.Element: KeyValueCollectionTreeProtocol,
        C.Element.Key == Key,
        C.Element.Value == Value,
        C.Element.SubCollection.Index == List.Index {
            replace(i..<i, in: pk, with: c)
    }
    mutating func append(_ e: (key: Key, value: Value), in pk: Key?) {
        let c = collection(of: pk).endIndex
        insert(contentsOf: CollectionOfOne(e), at: c, in: pk)
    }
}
/// Convenient extension methods that requires `List.Index == Int`.
public extension ReplaceableKVLTStorageProtocol where List.Index == Int {
    mutating func insert<T>(_ t: T, at i: List.Index, in pk: Key?) where
    T: KeyValueCollectionTreeProtocol,
    T.Key == Key,
    T.Value == Value,
    T.SubCollection.Index == List.Index {
        replace(i..<i, in: pk, with: CollectionOfOne(t))
    }
    mutating func insert(_ e: (key: Key, value: Value), at i: List.Index, in pk: Key?) {
        insert(contentsOf: CollectionOfOne(e), at: i, in: pk)
    }
    mutating func remove(_ subrange: Range<List.Index>, in pk: Key?) {
        replace(subrange, in: pk, with: EmptyCollection<EmptyyKVLT>())
    }
    mutating func remove(at i: List.Index, in pk: Key?) {
        replace(i..<i+1, in: pk, with: EmptyCollection<EmptyyKVLT>())
    }
}
