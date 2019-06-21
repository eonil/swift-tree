//
//  Tree.swift
//  Tree
//
//  Created by Henry on 2019/06/21.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

/// An implementation of `TreeCollection`.
public struct Tree<Element>: TreeCollection {
    private var impl = Impl()
    private var root: Impl.Identity?
    init() {}
}
extension Tree {
    typealias Impl = DSRefMapTree<Element>
}

// MARK: Index based operations.
public extension Tree {
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
    typealias Impl = DSRefMapTree<Element>
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

// MARK: Path based operations.
public extension Tree {
    typealias Path = IndexPath
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

// MARK: Path query.
public extension Tree {
    func index(for p: IndexPath) -> TreeIndex<Element> {
        let id = impl.findIdentity(for: p)
        let i = impl.index(for: id)
        return Index(impl: i)
    }
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
public extension Tree.Paths {
    typealias Path = IndexPath
    var startIndex: Index { Tree.Paths.Index(impl: start) }
    var endIndex: Index { Tree.Paths.Index(impl: end) }
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
public extension Tree.Paths.Index {
    static func < (lhs: Tree.Paths.Index, rhs: Tree.Paths.Index) -> Bool {
        return lhs.impl < rhs.impl
    }
}

// MARK: Subpath query.
public extension Tree {
    func subpaths(of p: IndexPath = []) -> Subpaths {
        precondition(impl.rootID != nil, "Path is out of range.")
        let id = impl.findIdentity(for: p, from: impl.rootID!)
        let cs = impl.children(of: id)
        return Subpaths(path: p, childCount: cs.count)
    }
    struct Subpaths: RandomAccessCollection {
        var path: Path
        var childCount: Int
    }
}
public extension Tree.Subpaths {
    var startIndex: Int { 0 }
    var endIndex: Int { childCount }
    subscript(_ i: Int) -> Tree.Path {
        return path.appending(i)
    }
}

// MARK: Recursive navigation view.
public extension Tree {
    /// Convenient view to navigate subtrees.
    var subtree: Subtree? {
        guard impl.rootID != nil else { return nil }
        let id = impl.rootID!
        let p = [] as IndexPath
        return Subtree(impl: impl, id: id, px: p)
    }
    struct Subtree {
        var impl: Impl
        var id: Impl.Identity
        var px: Path
    }
    struct Subtrees: RandomAccessCollection {
        var impl: Impl
        var parentPath: Path
        var childrenIDs: [DSIdentity]
    }
}
public extension Tree.Subtree {
    var index: Tree.Index { Tree.Index(impl: impl.index(for: id)) }
    var path: Tree.Path { px }
    var element: Tree.Element { impl.state(of: id) }
    var subtrees: Tree.Subtrees {
        let cs = impl.children(of: id)
        return Tree.Subtrees(impl: impl, parentPath: px, childrenIDs: cs)
    }
}
public extension Tree.Subtrees {
    var startIndex: Int { 0 }
    var endIndex: Int { childrenIDs.count }
    subscript(_ i: Int) -> Tree.Subtree {
        let id = childrenIDs[i]
        let p = parentPath.appending(i)
        return Tree.Subtree(impl: impl, id: id, px: p)
    }
}
