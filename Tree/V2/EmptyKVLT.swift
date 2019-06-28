//
//  EmptyKVLT.swift
//  Tree
//
//  Created by Henry on 2019/06/27.
//  Copyright © 2019 Eonil. All rights reserved.
//

/// A utility placeholder type for empty instance.
struct EmptyyKVLT<Key,Value>: KVLTProtocol where
Key: Comparable {
    public init() {}
}
extension EmptyyKVLT {
    var key: Key { fatalError() }
    var value: Value { fatalError() }
    var collection: [EmptyyKVLT] { return [] }
}
extension EmptyyKVLT {
    subscript(_ k: Key) -> Value {
        get { fatalError() }
        set(v) { fatalError() }
    }
    func collection(of pk: Key?) -> [EmptyyKVLT] { return [] }
    func tree(for k: Key) -> EmptyyKVLT { return EmptyyKVLT() }
}
