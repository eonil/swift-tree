//
//  OrderedMapTreeProtocol.swift
//  Tree
//
//  Created by Henry on 2019/06/27.
//  Copyright © 2019 Eonil. All rights reserved.
//

/// A read-only ordered map-tree.
public protocol OrderedMapTreeProtocol: Collection where
Element == (key: Key, value: Value) {
    associatedtype Key
    associatedtype Value
    associatedtype Subtree: OrderedMapSubtreeProtocol where
        Subtree.Index == Int,
        Subtree.Key == Key,
        Subtree.Value == Value
    subscript(_: Key) -> Value { get }
    func subtree(for: Key?) -> Subtree
}
public protocol OrderedMapSubtreeProtocol: RandomAccessCollection where
Element == (key: Key, value: Value) {
    associatedtype Key
    associatedtype Value
    func subtree(at: Int) -> Self
}

extension PersistentOrderedMapTree: OrderedMapTreeProtocol {}
extension PersistentOrderedMapTree.Subtree: OrderedMapSubtreeProtocol {}
