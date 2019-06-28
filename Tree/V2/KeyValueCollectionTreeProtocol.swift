//
//  KeyValueCollectionTreeProtocol.swift
//  Tree
//
//  Created by Henry on 2019/06/28.
//  Copyright © 2019 Eonil. All rights reserved.
//

public protocol KeyValueCollectionTreeProtocol: CollectionTreeProtocol {
    associatedtype Key
    associatedtype Value
    var key: Key { get }
    var value: Value { get }
}

