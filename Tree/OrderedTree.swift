//
//  OrderedTree.swift
//  Tree
//
//  Created by Henry on 2019/06/24.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

/// A storage that organized internal elements in tree shape.
///
/// This is most basic form of trees. As this does not require identities
/// for elements, you can use this type like nested array.
///
/// In many cases, you need explicit node identities (keys) for performant tree
/// operations. In that case, use `OrderedTreeMap` type.
///
/// - `OrderedTree` provides `IndexPath` based interfaces.
/// - `OrderedTree` also provides object-oriented `Subtree` based interface.
/// - You can use this type in either way you like.
///
public struct OrderedTree<Element> {
    private(set) var impl: IMPL
    typealias IMPL = IMPLOrderedTreeMap<II,Element>
    typealias II = IMPLImplicitIdentity
    public init(_ e: Element) {
        impl = IMPL(root: (II(),e))
    }
    init(impl x: IMPL) {
        impl = x
    }
}

public extension OrderedTree {
    var isEmpty: Bool {
        return impl.stateMap.isEmpty
    }
    var count: Int {
        return impl.stateMap.count
    }

//    subscript(_ p: IndexPath) -> Subtree {
//        return subtree[p]
//    }
    subscript(_ p: IndexPath) -> Element {
        get { return subtree.subtree(at: p).value }
        set(v) {
            let s = subtree.subtree(at: p) as Subtree
            impl.setState(v, for: s.key)
        }
    }
    mutating func insert(_ e: Element, at p: IndexPath) {
        let i = p.last!
        let q = p.dropLast()
        var s = subtree.subtree(at: q) as Subtree
        s.insert(e, at: i)
        self = s.tree
    }
    mutating func remove(at p: IndexPath) {
        let i = p.last!
        let q = p.dropLast()
        var s = subtree.subtree(at: q) as Subtree
        s.remove(at: i)
        self = s.tree
    }
}

public extension OrderedTree {
    /// Root subtree.
    var subtree: Subtree {
        let cks = impl.linkageMap[impl.rootKey]!
        return Subtree(impl: impl, key: impl.rootKey, subkeys: cks)
    }
    /// Represents a subtree in a tree.
    /// - This is a convenient object-oriented interface.
    /// - You can iterate direct children in this subtree node
    ///   using `RandomAccessCollection` interface.
    /// - You also can query child subtrees using `subtree(at:)` method.
    /// - You can perform mutations on subtree.
    /// - Modified tree can be obtained from `tree` property.
    /// - Mutation on subtree won't affect original tree.
    ///   Instead, a new version of tree will be created.
    struct Subtree: RandomAccessCollection {
        var impl: IMPL
        var key: II
        var subkeys: IMPL.Children
    }
}
public extension OrderedTree.Subtree {
    typealias Index = Int
    init(_ e: Element) {
        self = OrderedTree(e).subtree
    }
    var tree: OrderedTree {
        return OrderedTree(impl: impl)
    }
    var startIndex: Int {
        return 0
    }
    var endIndex: Int {
        return subkeys.count
    }
    subscript(_ i: Int) -> Element {
        let ck = subkeys[i]
        return impl.stateMap[ck]!
    }
    /// Replaces subtrees in range with new subtrees recursively.
    mutating func replaceSubtrees<C>(_ subrange: Range<Int>, with newSubtrees: C) where C: Collection, C.Element == OrderedTree.Subtree {
        let ts1 = newSubtrees.lazy.map({ t in t.impl })
        impl.replaceSubtrees(subrange, in: key, with: ts1)
        // Update local cache.
        subkeys = impl.linkageMap[key]!
    }
    /// Replaces subtrees in range with new elements as new subtrees
    mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C: Collection, C.Element == Element {
        let kvs1 = newElements.lazy.map({ e in (OrderedTree.II(),e) })
        impl.replaceSubrange(subrange, in: key, with: kvs1)
        // Update local cache.
        subkeys = impl.linkageMap[key]!
    }
    /// Inserts a subtree at index recursively.
    mutating func insert(_ s: OrderedTree.Subtree, at i: Int) {
        replaceSubtrees(i..<i, with: [s])
    }
    /// Inserts an element as a subtree.
    mutating func insert(_ e: Element, at i: Int) {
        replaceSubrange(i..<i, with: [e])
    }
    /// Removes subtree at index recursively.
    mutating func remove(at i: Int) {
        replaceSubrange(i..<i+1, with: [])
    }
}
extension OrderedTree.Subtree {
    var value: Element {
        get { return impl.stateMap[key]! }
        set(v) {
            impl.setState(v, for: key)
            // Update local cache.
            subkeys = impl.linkageMap[key]!
        }
    }
    func subtree(at i: Int) -> OrderedTree.Subtree {
        let ck = subkeys[i]
        let ccks = impl.linkageMap[ck]!
        return OrderedTree.Subtree(impl: impl, key: ck, subkeys: ccks)
    }
    func subtree(at p: IndexPath) -> OrderedTree.Subtree {
        switch p.count {
        case 0:
            return self
        default:
            let i = p.first!
            let q = p.dropFirst()
            return subtree(at: i).subtree(at: q)
        }
    }
//    subscript(_ p: IndexPath) -> Element {
//        get {
//            switch p.count {
//            case 0:
//                return impl.stateMap[key]!
//            default:
//                let i = p.first!
//                let q = p.dropFirst()
//                return self[i][q]
//            }
//        }
//        set(v) {
//            switch p.count {
//            case 0:
//                impl.replaceState(v, for: key)
//                // Update local cache.
//                subkeys = impl.linkageMap[key]!
//            default:
//                let s = self[p] as OrderedTree.Subtree
//                impl.replaceState(v, for: s.key)
//                // Update local cache.
//                subkeys = impl.linkageMap[key]!
//            }
//        }
//    }
//    subscript(_ i: Int) -> OrderedTree.Subtree {
//        return subtree(at: i)
//    }
//    subscript(_ p: IndexPath) -> OrderedTree.Subtree {
//        return subtree(at: p)
//    }
}
