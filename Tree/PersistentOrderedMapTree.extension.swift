//
//  PersistentOrderedMapTree.extension.swift
//  Tree
//
//  Created by Henry on 2019/06/24.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

public extension PersistentOrderedMapTree {
    subscript(_ p: IndexPath) -> Element {
        return subtree[p]
    }
    func subtree(at p: IndexPath) -> Subtree {
        return subtree.subtree(at: p)
    }
}

public extension PersistentOrderedMapTree.Subtree {
    subscript(_ p: IndexPath) -> Element {
        let s = subtree(at: p)
        let k = s.key
        let v = s.value
        return (k,v)
    }
    func subtree(at p: IndexPath) -> PersistentOrderedMapTree.Subtree {
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
