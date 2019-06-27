//
//  KVLTProtocol.swift
//  Tree
//
//  Created by Henry on 2019/06/27.
//  Copyright © 2019 Eonil. All rights reserved.
//

public protocol KVLTProtocol: MapTreeStorage where Key: Comparable {
    associatedtype Key
    associatedtype Value
    associatedtype List where
        List == Collection,
        List.Index == Int,
        List.Element == Tree
    associatedtype Tree where
        Tree.Key == Key,
        Tree.Value == Value,
        Tree.Collection == List
    subscript(_ k: Key) -> Value { get }
    func collection(of pk: Key?) -> List
    func tree(for k: Key) -> Tree
}

public protocol ReplaceableKVLTProtocol: KVLTProtocol, ReplaceableMapTreeStorage {
    subscript(_ k: Key) -> Value { get set }
    mutating func replace<C>(_ r: Range<Int>, in pk: Key?, with c: C) where
        C: Swift.Collection,
        C.Element: MapTree,
        C.Element.Key == Key,
        C.Element.Value == Value,
        C.Element.Collection.Index == List.Index
}
public extension ReplaceableKVLTProtocol {
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
    mutating func remove(_ subrange: Range<Int>, in pk: Key?) {
        replace(subrange, in: pk, with: EmptyyKVLT<Key,Value>.List())
    }
    mutating func remove(at i: Int, in pk: Key?) {
        replace(i..<i+1, in: pk, with: EmptyyKVLT<Key,Value>.List())
    }
}
