//
//  Tree.swift
//  Tree
//
//  Created by Henry on 2019/06/21.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

/// Default implementation of `TreeCollection`.
///
/// This is designed for copy-persistent scenario.
/// By using persistent back-end datastructures,
/// it's somewhat slower than ephemeral one for small dataset.
///
public struct PDTree<Element>: TreeCollection {
    private var impl = Impl()
    private var root: Impl.Identity?
    init() {}
}
extension PDTree {
    typealias Impl = DSPersistentRefMapTree<Element>
}

// MARK: Index Iteration
public extension PDTree {
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
    static func == (lhs: TreeIndex, rhs: TreeIndex) -> Bool {
        return lhs.impl == rhs.impl
    }
    static func < (lhs: TreeIndex, rhs: TreeIndex) -> Bool {
        return lhs.impl < rhs.impl
    }
}

// MARK: Path Operations
public extension PDTree {
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
    mutating func insert(_ e: Element, at p: Path) {
        impl.insert(e, at: p)
    }
    mutating func remove(at p: Path) {
        impl.remove(at: p)
    }

}

// MARK: Sorted Path Iteration
public extension PDTree {
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
public extension PDTree.Paths {
    typealias Path = IndexPath
    var startIndex: Index { PDTree.Paths.Index(impl: start) }
    var endIndex: Index { PDTree.Paths.Index(impl: end) }
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
public extension PDTree.Paths.Index {
    static func < (lhs: PDTree.Paths.Index, rhs: PDTree.Paths.Index) -> Bool {
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
public extension PDTree {
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
public extension PDTree.Subtree {
    var index: PDTree.Index { PDTree.Index(impl: impl.index(for: id)) }
    var path: PDTree.Path { px }
    var element: PDTree.Element { impl.state(of: id) }
    var subtrees: PDTree.Subtrees {
        let cs = impl.children(of: id)
        return PDTree.Subtrees(impl: impl, px: px, childrenIDs: cs)
    }
}
public extension PDTree.Subtrees {
    var startIndex: Int { 0 }
    var endIndex: Int { childrenIDs.count }
    subscript(_ i: Int) -> PDTree.Subtree {
        let id = childrenIDs[i]
        let p = px.appending(i)
        return PDTree.Subtree(impl: impl, id: id, px: p)
    }
}
