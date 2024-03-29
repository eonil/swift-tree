//
//  PersistentOrderedMapTree.Subtree.swift
//  Tree
//
//  Created by Henry on 2019/06/25.
//  Copyright © 2019 Eonil. All rights reserved.
//

// MARK: Subtree Access
public extension PersistentOrderedMapTree {
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
public extension PersistentOrderedMapTree.Subtree {
    typealias Index = Int
    typealias Element = (key: Key, value: Value)
    init(_ e: Element) {
        impl = PersistentOrderedMapTree(e).impl
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
    var tree: PersistentOrderedMapTree {
        return PersistentOrderedMapTree(impl: impl)
    }
    //    var index: OrderedTreeMap.Index? {
    //        guard let i = impl.stateMap.index(forKey: key) else { return nil }
    //        return OrderedTreeMap.Index(impl: i)
    //    }
    var startIndex: Int { return subkeys.startIndex }
    var endIndex: Int { return subkeys.endIndex }
    /// Search range is limited to direct children.
    func index(for key: Key) -> Int? {
        return subkeys.firstIndex(of: key)
    }
    subscript(_ i: Int) -> Element {
        get {
            let ck = subkeys[i]
            let cv = impl.stateMap[ck]!
            return (ck,cv)
        }
        @available(*,deprecated: 0, message: "This cannot provide proper performance. Use `remove/insert` methods instead of.")
        set(v) {
            replaceSubrange(i..<i+1, with: [v])
        }
    }
    func subtree(at i: Int) -> PersistentOrderedMapTree.Subtree {
        let k = subkeys[i]
        return subtree(for: k)!
    }
    /// Search range is limited to direct children.
    func subtree(for key: Key) -> PersistentOrderedMapTree.Subtree? {
        guard subkeys.contains(key) else { return nil }
        return tree.subtree(for: key)
    }
    /// Gets value for a key.
    /// Search range is limited to direct (shallow) children of current subtree.
    @available(*,deprecated: 0, message: "This cannot provide proper performance. Use `Tree[]` instead of.")
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
    mutating func replaceSubtrees<C>(_ subrange: Range<Int>, with newElements: C) where C: Collection, C.Element == PersistentOrderedMapTree.Subtree {
        let ts1 = newElements.lazy.map({ $0.impl })
        impl.replaceSubtrees(subrange, in: key, with: ts1)
        // Update local cache.
        subkeys = impl.linkageMap[key]!
    }
    /// Replaces subtrees in range with new elements as new subtrees
    /// - TODO:
    ///     We dont need to initialize `OrderedTreeMap` instance every time...
    mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C: Collection, C.Element == Element {
        replaceSubtrees(subrange, with: newElements.lazy.map({ e in PersistentOrderedMapTree.Subtree(e) }))
    }
    /// Inserts a subtree recursively at index.
    mutating func insert(_ s: PersistentOrderedMapTree.Subtree, at i: Int) {
        replaceSubtrees(i..<i, with: [s])
    }
    /// Inserts an element as a subtree.
    mutating func insert(_ e: Element, at i: Int) {
        let s = PersistentOrderedMapTree.Subtree(e)
        replaceSubtrees(i..<i, with: [s])
    }
    /// Removes a subtree recursively.
    mutating func remove(at i: Int) {
        replaceSubtrees(i..<i+1, with: [])
    }
}

// MARK: BFS
public extension PersistentOrderedMapTree.Subtree {
    var bfs: BFS { return BFS(impl: self) }
    struct BFS: Sequence {
        private(set) var impl: PersistentOrderedMapTree.Subtree
    }
}
public extension PersistentOrderedMapTree.Subtree.BFS {
    __consuming func makeIterator() -> PersistentOrderedMapTree.Subtree.BFS.Iterator {
        let it = IMPLPersistentOrderedMapTreeBFS<Key,Value>(impl.impl, from: impl.key)
        return Iterator(impl: it)
    }
    struct Iterator: IteratorProtocol {
        private(set) var impl: IMPLPersistentOrderedMapTreeBFS<Key,Value>
    }
}
public extension PersistentOrderedMapTree.Subtree.BFS.Iterator {
    mutating func next() -> PersistentOrderedMapTree.Element? {
        guard let k = impl.target else { return nil }
        let v = impl.source.stateMap[k]!
        impl.step()
        return (k,v)
    }
}


// MARK: DFS
public extension PersistentOrderedMapTree.Subtree {
    var dfs: DFS { return DFS(impl: self) }
    struct DFS: Sequence {
        private(set) var impl: PersistentOrderedMapTree.Subtree
    }
}
public extension PersistentOrderedMapTree.Subtree.DFS {
    __consuming func makeIterator() -> PersistentOrderedMapTree.Subtree.DFS.Iterator {
        let it = IMPLPersistentOrderedMapTreeDFS<Key,Value>(impl.impl, from: impl.key)
        return Iterator(impl: it)
    }
    struct Iterator: IteratorProtocol {
        private(set) var impl: IMPLPersistentOrderedMapTreeDFS<Key,Value>
    }
}
public extension PersistentOrderedMapTree.Subtree.DFS.Iterator {
    mutating func next() -> PersistentOrderedMapTree.Element? {
        guard let k = impl.target else { return nil }
        let v = impl.source.stateMap[k]!
        impl.step()
        return (k,v)
    }
}

