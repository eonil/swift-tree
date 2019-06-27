//
//  PersistentOrderedMapTree.pathUtil.swift
//  Tree
//
//  Created by Henry on 2019/06/26.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

public extension PersistentOrderedMapTree {
    subscript(_ p: IndexPath) -> Element {
        let e = subtree[p]
        return (e.key,e.value)
    }
    func subtree(at p: IndexPath) -> Subtree {
        return subtree.subtree(at: p)
    }
}

public extension PersistentOrderedMapTree.Subtree {
    subscript(_ p: IndexPath) -> Element {
        let s = subtree(at: p)
        precondition(
            s.key != nil,
            "Path is out of range. There's no element at path.")
        let k = s.key! // At this point key cannot be `nil`.
        return Element(impl: impl, k: k, idx: p.last!)
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
