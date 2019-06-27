//
//  EmptyKVLT.swift
//  Tree
//
//  Created by Henry on 2019/06/27.
//  Copyright © 2019 Eonil. All rights reserved.
//

public struct EmptyyKVLT<Key,Value>:
KVLTStorageProtocol, ReplaceableKVLTProtocol where
Key: Comparable {
    public init() {}
}
public extension EmptyyKVLT {
    /// Root collection.
    var collection: List { return List() }
    struct List: KVLTListProtocol {}
    struct Tree: KVLTProtocol {}
}
public extension EmptyyKVLT {
    subscript(_ k: Key) -> Value {
        get { fatalError() }
        set(v) { fatalError() }
    }
    func collection(of pk: Key?) -> List { return List() }
    func tree(for k: Key) -> Tree { return Tree() }
}
public extension EmptyyKVLT {
    mutating func replace<C>(_ r: Range<Int>, in pk: Key?, with c: C) where
    C: Swift.Collection,
    C.Element: MapTree,
    C.Element.Key == Key,
    C.Element.Value == Value,
    C.Element.Collection.Index == List.Index {
        fatalError()
    }
}
public extension EmptyyKVLT.List {
    typealias Tree = EmptyyKVLT.Tree
    var startIndex: Int { return 0 }
    var endIndex: Int { return 0 }
    subscript(_ i: Int) -> Tree { return Tree() }
}
public extension EmptyyKVLT.Tree {
    typealias List = EmptyyKVLT.List
    var key: Key { fatalError() }
    var value: Value { fatalError() }
    var collection: List { return List() }
}


