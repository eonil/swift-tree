//
//  KVLTProtocol.swift
//  Tree
//
//  Created by Henry on 2019/06/27.
//  Copyright © 2019 Eonil. All rights reserved.
//

public protocol KVLTStorageProtocol: MapTreeStorage where
Key: Comparable,
Collection == List {
    associatedtype Key
    associatedtype Value
    associatedtype List: KVLTListProtocol
    associatedtype Tree: KVLTProtocol
    subscript(_ k: Key) -> Value { get }
    func collection(of pk: Key?) -> List
    func tree(for k: Key) -> Tree
}
public protocol KVLTListProtocol: MapTreeCollection where
Index == Int,
Element: KVLTProtocol {
}
public protocol KVLTProtocol: MapTree where
Collection: KVLTListProtocol {
}

public protocol ReplaceableKVLTStorageProtocol: KVLTStorageProtocol, ReplaceableMapTreeStorage {
    subscript(_ k: Key) -> Value { get set }
    mutating func replace<C>(_ r: Range<Int>, in pk: Key?, with c: C) where
        C: Swift.Collection,
        C.Element: MapTree,
        C.Element.Key == Key,
        C.Element.Value == Value,
        C.Element.Collection.Index == List.Index
    mutating func insert<C>(contentsOf c: C, at i: Int, in pk: Key?) where
        C: Swift.Collection,
        C.Element == (key: Key, value: Value)
}
public extension ReplaceableKVLTStorageProtocol {
    mutating func insert<C>(contentsOf c: C, at i: Int, in pk: Key?) where
        C: Swift.Collection,
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
    mutating func insert(_ e: (key: Key, value: Value), at i: Int, in pk: Key?) {
        insert(contentsOf: CollectionOfOne(e), at: i, in: pk)
    }
    mutating func remove(_ subrange: Range<Int>, in pk: Key?) {
        replace(subrange, in: pk, with: EmptyyKVLT<Key,Value>.List())
    }
    mutating func remove(at i: Int, in pk: Key?) {
        replace(i..<i+1, in: pk, with: EmptyyKVLT<Key,Value>.List())
    }
}
