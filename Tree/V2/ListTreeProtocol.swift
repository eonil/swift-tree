//
//  ListTreeProtocol.swift
//  Tree
//
//  Created by Henry on 2019/06/28.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

public protocol ListTreeProtocol: CollectionTreeProtocol where
SubCollection: RandomAccessCollection,
SubCollection.Index == Int {
    associatedtype Value
    init(value: Value)
    var value: Value { get }
    subscript(_: IndexPath) -> Self { get }
}

public protocol ReplaceableListTreeProtocol: ListTreeProtocol where
SubCollection: MutableCollection & RangeReplaceableCollection {
    var value: Value { get set }
    var collection: SubCollection { get set }
    subscript(_: IndexPath) -> Self { get set }
}

