//
//  KVLTProtocol.map.swift
//  Tree
//
//  Created by Henry on 2019/06/29.
//  Copyright © 2019 Eonil. All rights reserved.
//

public extension KVLTProtocol {
    /// Maps to a `ListTree` instance.
    func map() -> ListTree<(key: Key, value: Value)> {
        return ListTree(self)
    }
}
