//
//  PersistentTree.swift
//  Tree
//
//  Created by Henry on 2019/06/21.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

/// Default implementation of `Tree`.
///
/// This is designed for copy-persistent scenario.
/// By using persistent back-end datastructures,
/// it's somewhat slower than ephemeral one for small dataset.
///
public struct PersistentTree<Element>:
Sequence,
Collection,
RandomAccessCollection,
Tree,
MutableTree,
NodeReplaceableTree {
    private var impl = Impl()
    private var root: Impl.Identity?
    public init() {}
}
extension PersistentTree {
    typealias Impl = DSPersistentRefMapTree<Element>
}

// MARK: Mutations
public extension PersistentTree {
    mutating func insert(_ e: Element, at p: Path) {
        impl.insert(e, at: p)
    }
    mutating func insertSubtree<S>(_ s: S, at p: IndexPath) where S : Tree, Element == S.Element, Path == S.Path {
        for p1 in s.paths {
            let p2 = p.appending(p1)
            let e = s[p2]
            insert(e, at: p2)
        }
    }
    mutating func replaceSubtree<S>(at p: Path, with s: S) where S : Tree, Element == S.Element, Path == S.Path {
        removeSubtree(at: p)
        insertSubtree(s, at: p)
    }
    mutating func removeSubtree(at p: Path) {
        impl.remove(at: p)
    }
}

// MARK: Unsorted Index Iteration
public extension PersistentTree {
    var startIndex: Index {
        return Index(impl: impl.startIndex)
    }
    var endIndex: Index {
        return Index(impl: impl.endIndex)
    }
    func index(after i: Index) -> Index {
        return Index(impl: impl.index(after: i.impl))
    }
    func index(before i: Index) -> Index {
        return Index(impl: impl.index(before: i.impl))
    }
}
// MARK: Index Operations
public extension PersistentTree {
    func index(_ i: Index, offsetBy d: Index.Stride) -> Index {
        return Index(impl: impl.index(i.impl, offsetBy: d))
    }
    func distance(from a: Index, to b: Index) -> Index.Stride {
        return impl.distance(from: a.impl, to: b.impl)
    }
    subscript(_ i: Index) -> Element {
        get { return impl[i.impl] }
        set(v) { impl[i.impl] = v }
    }
    typealias Index = TreeIndex<Element>
}
public struct TreeIndex<Element>: Comparable {
    typealias Impl = DSPersistentRefMapTree<Element>
    var impl: Impl.Index
}
public extension TreeIndex {
    typealias Stride = Int
    static func == (lhs: TreeIndex, rhs: TreeIndex) -> Bool {
        return lhs.impl == rhs.impl
    }
    static func < (lhs: TreeIndex, rhs: TreeIndex) -> Bool {
        return lhs.impl < rhs.impl
    }
}

// MARK: Path Operations
public extension PersistentTree {
    typealias Path = IndexPath
    func index(for p: IndexPath) -> TreeIndex<Element> {
        let id = impl.findIdentity(for: p)
        let i = impl.index(for: id)
        return Index(impl: i)
    }
    subscript(_ p: IndexPath) -> Element {
        get {
            precondition(impl.rootID != nil, "Path is out of range.")
            let id = impl.findIdentity(for: p)
            return impl.state(of: id)
        }
        set(v) {
            precondition(impl.rootID != nil, "Path is out of range.")
            let id = impl.findIdentity(for: p)
            return impl.setState(of: id, as: v)
        }
    }
//    mutating func remove(at p: Path) {
//        impl.remove(at: p)
//    }
}

// MARK: Sorted Path Iteration
public extension PersistentTree {
    var paths: Paths {
        let a = DSCursor(source: impl, path: [])
        let b = DSCursor(source: impl)
        return Paths(start: a, end: b)
    }
    struct Paths: Collection {
        var start: Cursor
        var end: Cursor
        typealias Cursor = DSCursor<Element>
    }
}
public extension PersistentTree.Paths {
    typealias Path = IndexPath
    var startIndex: Index { PersistentTree.Paths.Index(impl: start) }
    var endIndex: Index { PersistentTree.Paths.Index(impl: end) }
    func index(after i: Index) -> Index {
        let c = i.impl.nextDFS ?? Cursor(source: i.impl.source)
        return Index(impl: c)
    }
    subscript(_ i: Index) -> Path {
        return i.impl.position
    }
    struct Index: Comparable {
        var impl: Cursor
        typealias Cursor = DSCursor<Element>
    }
}
public extension PersistentTree.Paths.Index {
    static func < (lhs: PersistentTree.Paths.Index, rhs: PersistentTree.Paths.Index) -> Bool {
        return lhs.impl < rhs.impl
    }
}

//// MARK: Subpath query.
//public extension PDTree {
//    func subpaths(of p: IndexPath = []) -> Subpaths {
//        precondition(impl.rootID != nil, "Path is out of range.")
//        let id = impl.findIdentity(for: p, from: impl.rootID!)
//        let cs = impl.children(of: id)
//        return Subpaths(path: p, childCount: cs.count)
//    }
//    struct Subpaths: RandomAccessCollection {
//        var path: Path
//        var childCount: Int
//    }
//}
//public extension PDTree.Subpaths {
//    var startIndex: Int { 0 }
//    var endIndex: Int { childCount }
//    subscript(_ i: Int) -> PDTree.Path {
//        return path.appending(i)
//    }
//}

// MARK: Recursive Subtree Navigation
public extension PersistentTree {
    /// Convenient view to navigate subtrees.
    var subtree: Subtree? {
        guard impl.rootID != nil else { return nil }
        let id = impl.rootID!
        let p = [] as IndexPath
        return Subtree(impl: impl, id: id, px: p)
    }
    struct Subtree: SubtreeProtocol {
        var impl: Impl
        var id: Impl.Identity
        var px: Path
    }
    struct Subtrees: RandomAccessCollection {
        var impl: Impl
        var px: Path
        var childrenIDs: Impl.IdentityCollection
    }
}
public extension PersistentTree.Subtree {
    var index: PersistentTree.Index { PersistentTree.Index(impl: impl.index(for: id)) }
    var path: PersistentTree.Path { px }
    var element: PersistentTree.Element { impl.state(of: id) }
    var subtrees: PersistentTree.Subtrees {
        let cs = impl.children(of: id)
        return PersistentTree.Subtrees(impl: impl, px: px, childrenIDs: cs)
    }
}
public extension PersistentTree.Subtrees {
    var startIndex: Int { 0 }
    var endIndex: Int { childrenIDs.count }
    subscript(_ i: Int) -> PersistentTree.Subtree {
        let id = childrenIDs[i]
        let p = px.appending(i)
        return PersistentTree.Subtree(impl: impl, id: id, px: p)
    }
}
