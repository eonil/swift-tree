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
/// - Singly rooted tree.
/// - Path `[]` is invalid and unaccepted.
///
/// Map-Like Read, Tree-Like Write
/// ------------------------------
/// - You can query value for a key like a map.
/// - You need explicit position to write into tree.
///   Therefore, you cannot write with map-like interface.
///
/// Subtree based Access
/// --------------------
/// - You can navigate tree substructures with object-oriented interface.
/// - You can perform mutation directly on subtree.
/// - You can retrieve mutation result directly from subtree.
///
public struct OrderedTreeMap<Key,Value> where Key:Comparable {
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
    subscript(_ key: Key) -> Value? {
        return impl.stateMap[key]
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
    var startIndex: Int { subkeys.startIndex }
    var endIndex: Int { subkeys.endIndex }
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
    subscript(_ i: Int) -> OrderedTreeMap.Subtree {
        get {
            let k = subkeys[i]
            let cks = impl.linkageMap[k]!
            return OrderedTreeMap.Subtree(impl: impl, key: k, subkeys: cks)
        }
        set(v) { replaceSubtrees(i..<i+1, with: [v]) }
    }
    /// Gets value for a key.
    /// Search range is limited to direct (shallow) children of current subtree.
    subscript(_ k: Key) -> Value? {
        return subkeys.contains(k) ? impl.stateMap[k] : nil
    }
    /// Gets current base tree-map.
    /// If you perform mutation on subtree, this will give you modified version of tree.
    /// Mutation on a subtree won't affect original base tree.
    /// Instead, a new version of tree will be created.
    var tree: OrderedTreeMap {
        return OrderedTreeMap(impl: impl)
    }

    mutating func replaceSubtrees<C>(_ subrange: Range<Int>, with newElements: C) where C: Collection, C.Element == OrderedTreeMap.Subtree {
        let ts1 = newElements.lazy.map({ $0.impl })
        impl.replaceSubrange(subrange, in: key, with: ts1)
    }
//    mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C: Collection, C.Element == Element {
//        replaceSubrange(subrange, with: newElements.lazy.map({ e in OrderedTreeMap.Subtree(e) }))
//    }
    mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C: Collection, C.Element == Element {
        let es1 = newElements.lazy.map({ k,v in (k,v) })
        impl.replaceSubrange(subrange, in: key, with: es1)
    }
}


// MARK: BFS
public extension OrderedTreeMap.Subtree {
    var bfs: BFS { BFS(impl: self) }
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
    var dfs: DFS { DFS(impl: self) }
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

