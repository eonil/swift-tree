//
//  PersistentOrderedRootlessMapTree.swift
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
///   Use `PersistentOrderedRootlessMapTree` interface
///   for setting values for keys.
///
public struct PersistentOrderedRootlessMapTree<Key,Value>: Collection where
Key: Comparable {
    private(set) var impl = IMPL()
    typealias IMPL = IMPLPersistentOrderedRootlessMapTree<Key,Value>
    typealias Subkeys = IMPL.Subkeys
    public init() {}
    init(impl x: IMPL) {
        impl = x
    }
}
public extension PersistentOrderedRootlessMapTree {
    subscript(_ k: Key) -> Value {
        get { return impl.value(for: k) }
        set(v) { impl.setValue(v, for: k) }
    }
}

// MARK: Mutators
public extension PersistentOrderedRootlessMapTree {
    mutating func append(_ e: Element, in pk: Key?) {
        insert(e, at: count, in: pk)
    }
    mutating func insert(_ e: Element, at i: Int, in pk: Key?) {
        impl.insert(e, at: i, in: pk)
    }
    mutating func insert<C>(contentsOf es: C, at i: Int, in pk: Key?) where C: Collection, C.Element == Element {
        impl.insert(contentsOf: es.lazy.map({ k,v in (k,v) }), at: i, in: pk)
    }
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
public extension PersistentOrderedRootlessMapTree {
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
public extension PersistentOrderedRootlessMapTree.Index {
    static func < (lhs: PersistentOrderedRootlessMapTree.Index, rhs: PersistentOrderedRootlessMapTree.Index) -> Bool {
        return lhs.impl < rhs.impl
    }
}

// MARK: Subtree
public extension PersistentOrderedRootlessMapTree {
    /// Root subtree.
    var subtree: Subtree {
        return subtree(for: nil)
    }
    /// A subtree for key.
    /// - Parameter for k:
    ///     `nil` for root subtree.
    ///     Otherwise a key to the subtree.
    func subtree(for k: Key?) -> Subtree {
        return Subtree(impl: impl, key: k)
    }
    struct Subtree: RandomAccessCollection {
        var impl: IMPL
        var key: Key?
        var cachedSubkeys: Subkeys
        init(impl x: IMPL, key k: Key?) {
            impl = x
            key = k
            cachedSubkeys = impl.subkeys(for: k)
        }
    }
}
public extension PersistentOrderedRootlessMapTree.Subtree {
    typealias Tree = PersistentOrderedRootlessMapTree
    typealias Subtree = Tree.Subtree
    var tree: Tree {
        return Tree(impl: impl)
    }
    func subtree(at i: Int) -> Subtree {
        let sks = impl.subkeys(for: key)
        let sk = sks[i]
        return Subtree(impl: impl, key: sk)
    }
}
// MARK: Subtree.RandomAccessCollection
public extension PersistentOrderedRootlessMapTree.Subtree {
    typealias Index = Int
    typealias Element = (key: Key, value: Value)
    var startIndex: Index {
        return cachedSubkeys.startIndex
    }
    var endIndex: Index {
        return cachedSubkeys.endIndex
    }
    subscript(_ i: Index) -> Element {
        let sk = cachedSubkeys[i]
        let sv = impl.value(for: sk)
        return (sk,sv)
    }
    mutating func append(_ e: Element) {
        insert(e, at: count)
    }
    mutating func insert<C>(contentsOf es: C, at i: Int) where C: Collection, C.Element == Element {
        impl.insert(contentsOf: es.lazy.map({ (k,v) in (k,v) }), at: i, in: key)
        cachedSubkeys = impl.subkeys(for: key)
    }
    mutating func insert(_ e: Element, at i: Int) {
        impl.insert(e, at: i, in: key)
        cachedSubkeys = impl.subkeys(for: key)
    }
    /// This also removes subtrees in target range.
    mutating func removeSubrange(_ r: Range<Int>) {
        impl.removeSubtrees(r, in: key)
        cachedSubkeys = impl.subkeys(for: key)
    }
    /// This also removes subtrees at target index.
    mutating func remove(at i: Int) {
        impl.removeSubtree(at: i, in: key)
        cachedSubkeys = impl.subkeys(for: key)
    }
}
