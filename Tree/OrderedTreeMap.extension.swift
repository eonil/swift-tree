//
//  OrderedTreeMap.extension.swift
//  Tree
//
//  Created by Henry on 2019/06/24.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

public extension OrderedTreeMap {
    func subtree(at p: IndexPath) -> Subtree {
        return subtree[p]
    }
    subscript(_ p: IndexPath) -> Element {
        return subtree[p]
    }
}

public extension OrderedTreeMap.Subtree {
    subscript(_ p: IndexPath) -> Element {
        switch p.count {
        case 0:
            let k = key
            let v = impl.stateMap[k]!
            return (k,v)
        default:
            let i = p.first!
            let q = p.dropFirst()
            return self[i][q]
        }
    }
    subscript(_ p: IndexPath) -> OrderedTreeMap.Subtree {
        switch p.count {
        case 0:
            return self
        default:
            let i = p.first!
            let q = p.dropFirst()
            return self[i][q]
        }
    }
}
