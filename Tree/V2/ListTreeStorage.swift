//
//  ListTreeStorage.swift
//  Tree
//
//  Created by Henry on 2019/06/28.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation
import BTree

public struct ListTreeStorage<Value>:
ListTreeStorageProtocol,
ReplaceableListTreeStorageProtocol,
CustomReflectable {
    public var collection = List<ListTree<Value>>()
    public init() {}
}

/// Tree of lists.
public struct ListTree<Value>:
ListTreeProtocol,
ReplaceableListTreeProtocol,
CustomReflectable {
    public var value: Value
    public typealias SubCollection = List<ListTree<Value>>
    public var collection = SubCollection()
    public init(value v: Value) { value = v }
}
