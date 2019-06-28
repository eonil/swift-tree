//
//  KVLTStorage.map.swift
//  Tree
//
//  Created by Henry on 2019/06/27.
//  Copyright © 2019 Eonil. All rights reserved.
//

public extension KVLTStorage {
    /// Returns a new tree with mapped values.
    func mapValues<X>(_ fx: (Value) -> X) -> KVLTStorage<Key,X>  {
        return KVLTStorage<Key,X>(impl: impl.mapValues(fx))
    }
}
