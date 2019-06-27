//
//  PersistentOrderedMapTree.swift
//  Tree
//
//  Created by Henry on 2019/06/26.
//  Copyright © 2019 Eonil. All rights reserved.
//

/// A key-value storage that organizes elements in tree shape.
///
/// Map-Like Read, Tree-Like Write
/// ------------------------------
/// - You can query value for a key like a map.
/// - You need explicit position to write into tree.
///   Therefore, you cannot write with map-like interface.
///
/// Subtree based Access
/// --------------------
/// - You can access tree substructures with object-oriented interface using `Subtree`.
/// - You can modify tree structure directly on `Subtree`.
/// - You can retrieve modified result directly from `tree` property.
/// - `Subtree` does not support map-like value setter by key.
///   Having such interface makes semantics ambiguous
///   or comes with greatly dropped performance.
///   Use `PersistentOrderedMapTree` interface
///   for setting values for keys.
///
public struct PersistentOrderedMapTree<Key,Value>: Collection where
Key: Comparable {
    private(set) var impl = IMPL()
    typealias IMPL = IMPLPersistentOrderedMapTree<Key,Value>
    typealias Subkeys = IMPL.Subkeys
    public init() {}
    init(impl x: IMPL) {
        impl = x
    }
}
public extension PersistentOrderedMapTree {
    subscript(_ k: Key) -> Value {
        get { return impl.value(for: k) }
        set(v) { impl.setValue(v, for: k) }
    }
}

// MARK: Mutators
public extension PersistentOrderedMapTree {
    mutating func append(_ e: Element, in pk: Key?) {
        insert(e, at: count, in: pk)
    }
    mutating func insert(_ e: Element, at i: Int, in pk: Key?) {
        impl.insert(e, at: i, in: pk)
    }
    mutating func insert<C>(contentsOf es: C, at i: Int, in pk: Key?) where C: Collection, C.Element == Element {
        impl.insert(contentsOf: es.lazy.map({ k,v in (k,v) }), at: i, in: pk)
    }
//    /// This inserts all elements in supplied subtrees recursively.
//    /// All keys in all trees must be unique.
//    mutating func insertSubtree<T>(contentsOf t: T, at i: Int, in pk: Key?) where T: OrderedMapSubtreeProtocol, T.Element == Subtree.Element, T.Index == Subtree.Index {
//        for j in 0..<t.count {
//            let e = t[j]
//            insert(e, at: i+j, in: pk)
//            let (k,_) = e
//            let st = t.subtree(at: j)
//            insertSubtree(contentsOf: st, at: 0, in: k)
//        }
//    }
//    /// This inserts all elements in supplied subtrees recursively.
//    /// All keys in all trees must be unique.
//    mutating func insertSubtrees<C>(contentsOf c: C, at i: Int, in pk: Key?) where C: Collection, C.Element: OrderedMapSubtreeProtocol, C.Element.Element == Subtree.Element, C.Element.Index == Subtree.Index {
//
//    }
    /// Removes subtrees in range recursively.
    /// This method removes target element and all of its descendants.
    mutating func removeSubtrees(_ r: Range<Int>, in pk: Key?) {
        impl.removeSubtrees(r, in: pk)
    }
    /// Removes subtrees at index recursively.
    /// This method removes target element and all of its descendants.
    mutating func removeSubtree(at i: Int, in pk: Key?) {
        removeSubtrees(i..<i+1, in: pk)
    }
    /// This method fails if there's any child at the target subtree.
    mutating func removeSubrange(_ r: Range<Int>, in pk: Key?) {
        for (k,_) in subtree(for: pk) {
            precondition(
                impl.subkeys(for: k).isEmpty,
                "Target subtrees have some descendants. Remove the descendatns first.")
        }
        impl.removeSubtrees(r, in: pk)
    }
    /// This method fails if there's any child at the target subtree.
    mutating func remove(at i: Int, in pk: Key?) {
        removeSubrange(i..<i+1, in: pk)
    }
}

// MARK: Collection
public extension PersistentOrderedMapTree {
    var startIndex: Index {
        return Index(impl: impl.startIndex)
    }
    var endIndex: Index {
        return Index(impl: impl.endIndex)
    }
    func index(after i: Index) -> Index {
        return Index(impl: impl.index(after: i.impl))
    }
    subscript(_ i: Index) -> Element {
        return impl[i.impl]
    }
    typealias Element = (key: Key, value: Value)
    struct Index: Comparable {
        var impl: IMPL.Index
    }
}
public extension PersistentOrderedMapTree.Index {
    static func < (lhs: PersistentOrderedMapTree.Index, rhs: PersistentOrderedMapTree.Index) -> Bool {
        return lhs.impl < rhs.impl
    }
}
