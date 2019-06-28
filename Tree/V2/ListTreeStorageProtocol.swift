//
//  ListTreeProtocol.swift
//  Tree
//
//  Created by Henry on 2019/06/28.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

public protocol ListTreeStorageProtocol: CollectionTreeStorageProtocol where
Collection: RandomAccessCollection,
Collection.Index == Int,
Collection.Element: ListTreeProtocol,
Collection.Element.Value == Value {
    associatedtype Value
    typealias Tree = Collection.Element
    subscript(_: IndexPath) -> Tree { get }
}

public protocol ReplaceableListTreeStorageProtocol: ListTreeStorageProtocol where
Collection: MutableCollection & RangeReplaceableCollection,
Collection.Element: ReplaceableListTreeProtocol {
    var collection: Collection { get set }
    subscript(_: IndexPath) -> Tree { get set }
    mutating func insert(contentsOf: Tree, at: IndexPath)
    mutating func insert(_: Value, at: IndexPath)
    mutating func remove(at: IndexPath)
}

