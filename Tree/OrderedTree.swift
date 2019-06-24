//
//  OrderedTree.swift
//  Tree
//
//  Created by Henry on 2019/06/24.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

public struct OrderedTree<Element>  {
    private var impl: IMPL
    typealias IMPL = IMPLOrderedTreeMap<II,Element>
    typealias II = IMPLImplicitIdentity
    init(_ e: Element) {
        impl = IMPL(root: (II(),e))
    }
}

public extension OrderedTree {
    var subtree: Subtree {
        let cks = impl.linkageMap[impl.rootKey]!
        return Subtree(impl: impl, key: impl.rootKey, subkeys: cks)
    }
    struct Subtree {
        var impl: IMPL
        var key: II
        var subkeys: IMPL.Children
    }
    subscript(_ p: IndexPath) -> Subtree {
        return subtree[p]
    }
}

public extension OrderedTree.Subtree {
    init(_ e: Element) {
        self = OrderedTree(e).subtree
    }
    subscript(_ i: Int) -> Element {
        let ck = subkeys[i]
        return impl.stateMap[ck]!
    }
    subscript(_ i: Int) -> OrderedTree.Subtree {
        let ck = subkeys[i]
        let ccks = impl.linkageMap[ck]!
        return OrderedTree.Subtree(impl: impl, key: ck, subkeys: ccks)
    }
    subscript(_ p: IndexPath) -> Element {
        get {
            switch p.count {
            case 0:
                return impl.stateMap[key]!
            default:
                let i = p.first!
                let q = p.dropFirst()
                return self[i][q]
            }
        }
        set(v) {
            switch p.count {
            case 0:
                impl.replaceState(v, for: key)
            default:
                let s = self[p] as OrderedTree.Subtree
                impl.replaceState(v, for: s.key)
            }
        }
    }
    mutating func replaceSubtrees<C>(_ subrange: Range<Int>, with newSubtrees: C) where C: Collection, C.Element == OrderedTree.Subtree {
        let ts1 = newSubtrees.lazy.map({ t in t.impl })
        impl.replaceSubrange(subrange, in: key, with: ts1)
    }
    mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C: Collection, C.Element == Element {
        let kvs1 = newElements.lazy.map({ e in (OrderedTree.II(),e) })
        impl.replaceSubrange(subrange, in: key, with: kvs1)
    }
    mutating func insert(_ e: Element, at i: Int) {
        replaceSubrange(i..<i, with: [e])
    }
    mutating func remove(at i: Int) {
        replaceSubrange(i..<i+1, with: [])
    }
}
extension OrderedTree.Subtree {
    subscript(_ p: IndexPath) -> OrderedTree.Subtree {
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
