//
//  PersistentOrderedRootlessMapTree.pathUtil.swift
//  Tree
//
//  Created by Henry on 2019/06/26.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

public extension PersistentOrderedRootlessMapTree {
    subscript(_ p: IndexPath) -> Element {
        return subtree[p]
    }
    func subtree(at p: IndexPath) -> Subtree {
        return subtree.subtree(at: p)
    }
}

public extension PersistentOrderedRootlessMapTree.Subtree {
    subscript(_ p: IndexPath) -> Element {
        let s = subtree(at: p)
        precondition(
            s.key != nil,
            "Path is out of range. There's no element at path.")
        let k = s.key! // At this point key cannot be `nil`.
        let v = s.impl.value(for: k)
        return (k,v)
    }
    func subtree(at p: IndexPath) -> Subtree {
        switch p.count {
        case 0:
            return self
        default:
            let i = p.first!
            let q = p.dropFirst()
            return subtree(at: i).subtree(at: q)
        }
    }
}