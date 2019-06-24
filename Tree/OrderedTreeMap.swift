//
//  OrderedTreeMap.swift
//  Tree
//
//  Created by Henry on 2019/06/23.
//  Copyright © 2019 Eonil. All rights reserved.
//

/// A key-value storage that organizes internal elements in tree shape.
///
/// You can consider this as a map of `[key: Key: (value: Value, subtrees: [Self])]`.
///
/// Map-Like Read, Tree-Like Write
/// ------------------------------
/// - You can query value for a key like a map.
/// - You need explicit position to write into tree.
///   Therefore, you cannot write with map-like interface.
///
/// Subtree based Access
/// --------------------
/// - You can navigate tree substructures with object-oriented interface using `Subtree`.
/// - You can perform mutation directly on `Subtree`.
/// - You can retrieve mutation result directly from subtree.
///   Modified tree can be obtained from `Subtree.tree`.
///
public struct OrderedTreeMap<Key,Value>: BidirectionalCollection where Key:Comparable {
    private(set) var impl: IMPL
    typealias IMPL = IMPLOrderedTreeMap<Key,Value>
    /// Initializes a new ordered-tree-map instance with root element.
    public init(_ element: Element) {
        impl = IMPL(root: element)
    }
    private init(impl x: IMPL) {
        impl = x
    }
}

public extension OrderedTreeMap {
    func index(for key: Key) -> Index? {
        guard let i = impl.stateMap.index(forKey: key) else { return nil }
        return OrderedTreeMap.Index(impl: i)
    }
    subscript(_ key: Key) -> Value? {
        return impl.stateMap[key]
    }
}

//// MARK: Mutators
//public extension OrderedTreeMap {
//    /// Replaces subrange at non-root level.
//    mutating func replaceSubtrees<C>(_ subrange: OrderedTreeMapRange<Key>, with newSubtrees: C) where C: Collection, C.Element == OrderedTreeMap {
//        let ts1 = newSubtrees.lazy.map({ t in t.impl })
//        impl.replaceSubrange(subrange.range, in: subrange.key, with: ts1)
//    }
//    /// Replaces subrange at non-root level.
//    mutating func replaceSubrange<C>(_ subrange: OrderedTreeMapRange<Key>, with newElements: C) where C: Collection, C.Element == Element {
//        let es1 = newElements.lazy.map({ k,v in (k,v) })
//        impl.replaceSubrange(subrange.range, in: subrange.key, with: es1)
//    }
//    /// Replaces subrange at root level.
//    mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C: Collection, C.Element == Element {
//        let es1 = newElements.lazy.map({ k,v in (k,v) })
//        impl.replaceSubrange(subrange, in: impl.rootKey, with: es1)
//    }
//    /// Replaces subrange at non-root level.
//    mutating func replaceSubrange<C>(_ subrange: Range<Int>, in key: Key, with newElements: C) where C: Collection, C.Element == Element {
//        let es1 = newElements.lazy.map({ k,v in (k,v) })
//        impl.replaceSubrange(subrange, in: key, with: es1)
//    }
//}
//public struct OrderedTreeMapRange<Key> {
//    var key: Key
//    var range: Range<Int>
//}

// MARK: Collection Access
public extension OrderedTreeMap {
    typealias Element = (key: Key, value: Value)
    var isEmpty: Bool {
        return impl.stateMap.isEmpty
    }
    var count: Int {
        return impl.stateMap.count
    }
    var startIndex: Index {
        return Index(impl: impl.stateMap.startIndex)
    }
    var endIndex: Index {
        return Index(impl: impl.stateMap.endIndex)
    }
    func index(after i: Index) -> Index {
        return Index(impl: impl.stateMap.index(after: i.impl))
    }
    func index(before i: Index) -> Index {
        return Index(impl: impl.stateMap.index(before: i.impl))
    }
    subscript(_ i: Index) -> Element {
        return impl.stateMap[i.impl]
    }
    struct Index: Comparable {
        private(set) var impl: IMPL.StateMap.Index
    }
}
public extension OrderedTreeMap.Index {
    static func < (lhs: OrderedTreeMap.Index, rhs: OrderedTreeMap.Index) -> Bool {
        return lhs.impl < rhs.impl
    }
}

// MARK: Subtree Access
public extension OrderedTreeMap {
    /// Convenient access to each subtree.
    ///
    /// Implicit Shallow Iteration
    /// --------------------------
    /// `Subtree` provides iteration of `Element` at current level.
    /// If you want to iterate over deeper subtree elements, you need to
    /// navigate into deeper subtrees yourself.
    ///
    ///
    var subtree: Subtree {
        let cks = impl.linkageMap[impl.rootKey]!
        return Subtree(impl: impl, key: impl.rootKey, subkeys: cks)
    }
    /// Convenient access to each subtree.
    struct Subtree: RandomAccessCollection {
        private(set) var impl: IMPL
        private(set) var key: Key
        private(set) var subkeys: IMPL.Children
        var value: Value {
            get { return impl.stateMap[key]! }
            set(v) { impl.setState(v, for: key) }
        }
    }
}
public extension OrderedTreeMap.Subtree {
    typealias Index = Int
    typealias Element = (key: Key, value: Value)
    init(_ e: Element) {
        impl = OrderedTreeMap(e).impl
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
    var tree: OrderedTreeMap {
        return OrderedTreeMap(impl: impl)
    }
    var index: OrderedTreeMap.Index? {
        guard let i = impl.stateMap.index(forKey: key) else { return nil }
        return OrderedTreeMap.Index(impl: i)
    }
    var startIndex: Int { return subkeys.startIndex }
    var endIndex: Int { return subkeys.endIndex }
    func index(for key: Key) -> Int? {
        return subkeys.firstIndex(of: key)
    }
    subscript(_ i: Int) -> Element {
        get {
            let ck = subkeys[i]
            let cv = impl.stateMap[ck]!
            return (ck,cv)
        }
        set(v) {
            replaceSubrange(i..<i+1, with: [v])
        }
    }
    func subtree(at i: Int) -> OrderedTreeMap.Subtree {
        let k = subkeys[i]
        return subtree(for: k)!
    }
    func subtree(for key: Key) -> OrderedTreeMap.Subtree? {
        guard let cks = impl.linkageMap[key] else { return nil }
        return OrderedTreeMap.Subtree(impl: impl, key: key, subkeys: cks)
    }
    /// Gets value for a key.
    /// Search range is limited to direct (shallow) children of current subtree.
    subscript(_ k: Key) -> Value? {
        return subkeys.contains(k) ? impl.stateMap[k] : nil
    }
    /// Replaces subtrees in range with new subtrees recursively.
    mutating func replaceSubtrees<C>(_ subrange: Range<Int>, with newElements: C) where C: Collection, C.Element == OrderedTreeMap.Subtree {
        let ts1 = newElements.lazy.map({ $0.impl })
        impl.replaceSubtrees(subrange, in: key, with: ts1)
        // Update local cache.
        subkeys = impl.linkageMap[key]!
    }
    /// Replaces subtrees in range with new elements as new subtrees
    /// - TODO:
    ///     We dont need to initialize `OrderedTreeMap` instance every time...
    mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C: Collection, C.Element == Element {
        replaceSubtrees(subrange, with: newElements.lazy.map({ e in OrderedTreeMap.Subtree(e) }))
    }
    /// Inserts a subtree recursively at index.
    mutating func insert(_ s: OrderedTreeMap.Subtree, at i: Int) {
        replaceSubtrees(i..<i, with: [s])
    }
    /// Inserts an element as a subtree.
    mutating func insert(_ e: Element, at i: Int) {
        let s = OrderedTreeMap.Subtree(e)
        replaceSubtrees(i..<i, with: [s])
    }
    /// Removes a subtree recursively.
    mutating func remove(at i: Int) {
        replaceSubtrees(i..<i+1, with: [])
    }
}

// MARK: BFS
public extension OrderedTreeMap.Subtree {
    var bfs: BFS { return BFS(impl: self) }
    struct BFS: Sequence {
        private(set) var impl: OrderedTreeMap.Subtree
    }
}
public extension OrderedTreeMap.Subtree.BFS {
    __consuming func makeIterator() -> OrderedTreeMap.Subtree.BFS.Iterator {
        let it = IMPLOrderedTreeMapBFS<Key,Value>(impl.impl, from: impl.key)
        return Iterator(impl: it)
    }
    struct Iterator: IteratorProtocol {
        private(set) var impl: IMPLOrderedTreeMapBFS<Key,Value>
    }
}
public extension OrderedTreeMap.Subtree.BFS.Iterator {
    mutating func next() -> OrderedTreeMap.Element? {
        guard let k = impl.target else { return nil }
        let v = impl.source.stateMap[k]!
        impl.step()
        return (k,v)
    }
}


// MARK: DFS
public extension OrderedTreeMap.Subtree {
    var dfs: DFS { return DFS(impl: self) }
    struct DFS: Sequence {
        private(set) var impl: OrderedTreeMap.Subtree
    }
}
public extension OrderedTreeMap.Subtree.DFS {
    __consuming func makeIterator() -> OrderedTreeMap.Subtree.DFS.Iterator {
        let it = IMPLOrderedTreeMapDFS<Key,Value>(impl.impl, from: impl.key)
        return Iterator(impl: it)
    }
    struct Iterator: IteratorProtocol {
        private(set) var impl: IMPLOrderedTreeMapDFS<Key,Value>
    }
}
public extension OrderedTreeMap.Subtree.DFS.Iterator {
    mutating func next() -> OrderedTreeMap.Element? {
        guard let k = impl.target else { return nil }
        let v = impl.source.stateMap[k]!
        impl.step()
        return (k,v)
    }
}

