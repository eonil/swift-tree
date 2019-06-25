//
//  PersistentUnorderedTreeMap.Subtree.swift
//  Tree
//
//  Created by Henry on 2019/06/25.
//  Copyright © 2019 Eonil. All rights reserved.
//

import BTree

// MARK: Subtree Access
public extension PersistentUnorderedTreeMap {
    /// Convenient access to each subtree.
    ///
    /// Implicit Shallow Iteration
    /// --------------------------
    /// `Subtree` provides iteration of `Element` at current level.
    /// If you want to iterate over deeper subtree elements, you need to
    /// navigate into deeper subtrees yourself.
    ///
    var subtree: Subtree {
        let cks = impl.linkageMap[impl.rootKey]!
        return Subtree(impl: impl, key: impl.rootKey, subkeys: cks)
    }
    func subtree(for key: Key) -> Subtree? {
        guard let cks = impl.linkageMap[key] else { return nil }
        return Subtree(impl: impl, key: key, subkeys: cks)
    }
    /// Convenient access to each subtree.
    struct Subtree: Collection {
        private(set) var impl: IMPL
        private(set) var key: Key
        private(set) var subkeys: IMPL.Children
        var value: Value {
            get { return impl.stateMap[key]! }
            set(v) { impl.setState(v, for: key) }
        }
    }
}
public extension PersistentUnorderedTreeMap.Subtree {
    typealias Element = (key: Key, value: Value)
    init(_ e: Element) {
        impl = PersistentUnorderedTreeMap(e).impl
        key = e.key
        subkeys = impl.linkageMap[key]!
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
    var tree: PersistentUnorderedTreeMap {
        return PersistentUnorderedTreeMap(impl: impl)
    }
    struct Index: Comparable {
        private(set) var impl: SortedSet<Key>.Index
    }
}
public extension PersistentUnorderedTreeMap.Subtree.Index {
    static func == (lhs: PersistentUnorderedTreeMap.Subtree.Index, rhs: PersistentUnorderedTreeMap.Subtree.Index) -> Bool {
        return lhs.impl == rhs.impl
    }
    static func < (lhs: PersistentUnorderedTreeMap.Subtree.Index, rhs: PersistentUnorderedTreeMap.Subtree.Index) -> Bool {
        return lhs.impl < rhs.impl
    }
}
public extension PersistentUnorderedTreeMap.Subtree {
    var startIndex: Index { return Index(impl: subkeys.startIndex) }
    var endIndex: Index { return Index(impl: subkeys.endIndex) }
    func index(after i: Index) -> Index {
        return Index(impl: subkeys.index(after: i.impl))
    }
    /// Search range is limited to direct children.
    func index(for key: Key) -> Index? {
        guard let i = subkeys.index(of: key) else { return nil }
        return Index(impl: i)
    }
    /// Replacing an element can change key,
    /// and if key has been changed, index cannot be kept.
    /// Therefore, this does not support setting.
    subscript(_ i: Index) -> Element {
        get {
            let ck = subkeys[i.impl]
            let cv = impl.stateMap[ck]!
            return (ck,cv)
        }
    }
    func subtree(at i: Index) -> PersistentUnorderedTreeMap.Subtree {
        let k = subkeys[i.impl]
        return subtree(for: k)!
    }
}
public extension PersistentUnorderedTreeMap.Subtree {
    /// Search range is limited to direct children.
    func subtree(for key: Key) -> PersistentUnorderedTreeMap.Subtree? {
        guard subkeys.contains(key) else { return nil }
        return tree.subtree(for: key)
    }
    /// Gets value for a key.
    /// Search range is limited to direct (shallow) children of current subtree.
    subscript(_ k: Key) -> Value {
        get {
            precondition(subkeys.contains(k), "The key is not a direct child of this node.")
            return impl.stateMap[k]!
        }
        set(v) {
            precondition(subkeys.contains(k), "The key is not a direct child of this node.")
            impl.setState(v, for: k)
        }
    }
    /// Replaces subtrees in range with new subtrees recursively.
    mutating func replaceSubtree(_ k: Key, with newSubtree: PersistentUnorderedTreeMap.Subtree) {
        removeSubtree(k)
        insertSubtree(newSubtree)
    }
    /// Inserts a subtree recursively at index.
    mutating func insertSubtree(_ s: PersistentUnorderedTreeMap.Subtree) {
        let k = s.impl.rootKey
        precondition(subkeys.contains(k), "Supplied key is not a direct child of subtree.")
        impl.insertSubtree(s.impl, in: key)
    }
    /// Inserts an element as a subtree.
    mutating func insert(_ e: Element) {
        let k = e.0
        precondition(subkeys.contains(k), "Supplied key is not a direct child of subtree.")
        let s = IMPLPersitentUnorderedTreeMap(root: e)
        impl.insertSubtree(s, in: key)
    }
    /// Removes a subtree recursively.
    mutating func removeSubtree(_ k: Key) {
        precondition(subkeys.contains(k), "Supplied key is not a direct child of subtree.")
        impl.removeSubtree(k, in: key)
    }
}
