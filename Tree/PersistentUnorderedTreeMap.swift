//
//  PersistentUnorderedTreeMap.swift
//  Tree
//
//  Created by Henry on 2019/06/25.
//  Copyright © 2019 Eonil. All rights reserved.
//

import BTree

/// A key-value storage that organizes internal elements in tree shape.
///
/// You can consider this as a map of `[key: Key: (value: Value, subtrees: Set<Self>)]`.
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
public struct PersistentUnorderedTreeMap<Key,Value>: BidirectionalCollection where Key: Comparable {
    private(set) var impl: IMPL
    typealias IMPL = IMPLPersitentUnorderedTreeMap<Key,Value>
    /// Initializes a new ordered-tree-map instance with root element.
    public init(_ element: Element) {
        impl = IMPL(root: element)
    }
    init(impl x: IMPL) {
        impl = x
    }
}

public extension PersistentUnorderedTreeMap {
    func index(for key: Key) -> Index? {
        guard let i = impl.stateMap.index(forKey: key) else { return nil }
        return PersistentUnorderedTreeMap.Index(impl: i)
    }
    subscript(_ key: Key) -> Value {
        get { return impl.stateMap[key]! }
        set(v) { impl.setState(v, for: key) }
    }
}

//// MARK: Mutators
//public extension TreeMap {
//    /// Replaces subrange at non-root level.
//    mutating func replaceSubtrees<C>(_ subrange: TreeMapRange<Key>, with newSubtrees: C) where C: Collection, C.Element == TreeMap {
//        let ts1 = newSubtrees.lazy.map({ t in t.impl })
//        impl.replaceSubrange(subrange.range, in: subrange.key, with: ts1)
//    }
//    /// Replaces subrange at non-root level.
//    mutating func replaceSubrange<C>(_ subrange: TreeMapRange<Key>, with newElements: C) where C: Collection, C.Element == Element {
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
//public struct TreeMapRange<Key> {
//    var key: Key
//    var range: Range<Int>
//}

// MARK: Collection Access
public extension PersistentUnorderedTreeMap {
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
public extension PersistentUnorderedTreeMap.Index {
    static func < (lhs: PersistentUnorderedTreeMap.Index, rhs: PersistentUnorderedTreeMap.Index) -> Bool {
        return lhs.impl < rhs.impl
    }
}

//// MARK: BFS
//public extension TreeMap.Subtree {
//    var bfs: BFS { return BFS(impl: self) }
//    struct BFS: Sequence {
//        private(set) var impl: TreeMap.Subtree
//    }
//}
//public extension TreeMap.Subtree.BFS {
//    __consuming func makeIterator() -> TreeMap.Subtree.BFS.Iterator {
//        let it = IMPLTreeMapBFS<Key,Value>(impl.impl, from: impl.key)
//        return Iterator(impl: it)
//    }
//    struct Iterator: IteratorProtocol {
//        private(set) var impl: IMPLTreeMapBFS<Key,Value>
//    }
//}
//public extension TreeMap.Subtree.BFS.Iterator {
//    mutating func next() -> TreeMap.Element? {
//        guard let k = impl.target else { return nil }
//        let v = impl.source.stateMap[k]!
//        impl.step()
//        return (k,v)
//    }
//}
//
//
//// MARK: DFS
//public extension TreeMap.Subtree {
//    var dfs: DFS { return DFS(impl: self) }
//    struct DFS: Sequence {
//        private(set) var impl: TreeMap.Subtree
//    }
//}
//public extension TreeMap.Subtree.DFS {
//    __consuming func makeIterator() -> TreeMap.Subtree.DFS.Iterator {
//        let it = IMPLTreeMapDFS<Key,Value>(impl.impl, from: impl.key)
//        return Iterator(impl: it)
//    }
//    struct Iterator: IteratorProtocol {
//        private(set) var impl: IMPLTreeMapDFS<Key,Value>
//    }
//}
//public extension TreeMap.Subtree.DFS.Iterator {
//    mutating func next() -> TreeMap.Element? {
//        guard let k = impl.target else { return nil }
//        let v = impl.source.stateMap[k]!
//        impl.step()
//        return (k,v)
//    }
//}
//
