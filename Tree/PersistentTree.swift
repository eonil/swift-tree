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
/// Unsorted Collection Protocol Conformation
/// -----------------------------------------
/// Access to elements using `Index` protocol takes O(1) time
/// but only in random order.
///
/// Sorted Path Protocol Conformation
/// ---------------------------------
/// You can query paths and subpaths
///
public struct PersistentTree<Element>:
Sequence,
Collection,
MutableCollection,
Tree,
MutableTree,
NodeReplaceableTree {
    private var impl = Impl()
    private var root: Impl.Identity?
    public init() {}
}
extension PersistentTree {
    typealias Impl = ImplPersistentMapBasedTree<Element>
}

// MARK: Path Operations
public extension PersistentTree {
    typealias Path = IndexPath
    subscript(_ p: IndexPath) -> Element {
        /// - Complexity:
        ///     O(n * log(n)).
        get {
            precondition(impl.rootID != nil, "Path is out of range.")
            let id = impl.findIdentity(for: p)  // O(n * log(n))
            return impl.state(of: id)           // O(log(n))
        }
        /// - Complexity:
        ///     O(n * log(n)).
        set(v) {
            precondition(impl.rootID != nil, "Path is out of range.")
            let id = impl.findIdentity(for: p)  // O(n * log(n))
            return impl.setState(of: id, as: v) // O(log(n))
        }
    }
}
// MARK: Subpath Query
public extension PersistentTree {
    func subpaths(of p: IndexPath = []) -> SubPaths {
        precondition(impl.rootID != nil, "Path is out of range.")
        let id = impl.findIdentity(for: p, from: impl.rootID!)
        let cs = impl.children(of: id)
        return SubPaths(path: p, childCount: cs.count)
    }
    struct SubPaths: RandomAccessCollection {
        var path: Path
        var childCount: Int
    }
}
public extension PersistentTree.SubPaths {
    var startIndex: Int { 0 }
    var endIndex: Int { childCount }
    subscript(_ i: Int) -> PersistentTree.Path {
        return path.appending(i)
    }
}

// MARK: Sorted Path Iteration
public extension PersistentTree {
    var paths: Paths {
        let a = ImplCursor1(source: impl, path: [])
        let b = ImplCursor1(source: impl)
        return Paths(start: a, end: b)
    }
    struct Paths: Collection {
        var start: Cursor
        var end: Cursor
        typealias Cursor = ImplCursor1<Element>
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
        typealias Cursor = ImplCursor1<Element>
    }
}
public extension PersistentTree.Paths.Index {
    static func < (lhs: PersistentTree.Paths.Index, rhs: PersistentTree.Paths.Index) -> Bool {
        return lhs.impl < rhs.impl
    }
}




// MARK: Subtree Operations
public extension PersistentTree {
    /// - Complexity:
    ///     O(n * log(n)).
    mutating func insert(_ e: Element, at p: Path) {
        impl.insert(e, at: p)
    }
    /// - Complexity:
    ///     O(n^2).
    ///     Consider n as count after insertion.
    ///     Then, n = (n-m) + m.
    ///     At worst, m ==0 or m == n
    ///     Therefore, O(m * (m * log(m) + n * log(n))) becomes
    ///     One of O(0 * (0 * log(0) + n * log(n))) or O(m * (m * log(m) + 0 * log(0)))
    ///     First case becomes 0. Ignore it.
    ///     For second case, as m == n, as replace m to n.
    ///     → O(n * (n * log(n) + 0 * log(0)))
    ///     → O(n * (n * log(n)))
    ///     → O(n * n * log(n))
    ///     → O(n^2 * log(n))
    ///     → O(n^2)
    mutating func insertSubtree<S>(_ s: S, at p: IndexPath) where S : Tree, Element == S.Element, Path == S.Path {
        // Perform DFS.
        var stack = [IndexPath]()
        stack.append([])                    // O(n)
        while !stack.isEmpty {              // O(m * (m * log(m) + n * log(n)))
            let p1 = stack.removeFirst()    // O(n)
            let p2 = p.appending(p1)        // O(n)
            let e = s[p]                    // O(m * log(m))
            insert(e, at: p2)               // O(n * log(n)) where n is count(self) after insertion.
            let ps = s.subpaths(of: p1)     // O(1 * log(m)) where m is count(s). m <= n.
            stack.append(contentsOf: ps)
        }
    }
    /// - Complexity:
    ///     O(n^2).
    mutating func insertSubtree(_ s: PersistentTree, at p: IndexPath) {
        for p1 in s.paths {                 // O(m * log(m) * ...)
            let p2 = p.appending(p1)        // O(n)
            let e = s[p]                    // O(log(m))
            insert(e, at: p2)               // O(n * log(n))
        }
    }
    /// - Complexity:
    ///     O(n^2).
    mutating func replaceSubtree<S>(at p: Path, with s: S) where S : Tree, Element == S.Element, Path == S.Path {
        removeSubtree(at: p)                // O(n * log(n))
        insertSubtree(s, at: p)             // O(n^2)
    }
    /// - Complexity:
    ///     O(n^2).
    mutating func replaceSubtree(at p: Path, with s: PersistentTree) {
        removeSubtree(at: p)                // O(n * log(n))
        insertSubtree(s, at: p)             // O(n * log(n))
    }
    /// - Complexity:
    ///     O(n * log(n)).
    mutating func removeSubtree(at p: Path) {
        impl.remove(at: p)
    }
}

// MARK: Path to Index Conversion
public extension PersistentTree {
    func index(for p: IndexPath) -> TreeIndex<Element> {
        let id = impl.findIdentity(for: p)
        let i = impl.index(for: id)
        return Index(impl: i)
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
// MARK: Index Query
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
    typealias Impl = ImplPersistentMapBasedTree<Element>
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



//// MARK: Recursive Location Navigation
//public extension PersistentTree {
//    var location: Location? {
//        guard !impl.isEmpty else { return nil }
//        let id = impl.rootID!
//        return Location(impl: impl, id: id, px: [])
//    }
////    func location(for p: IndexPath) -> Location? {
////        guard !impl.isEmpty else { return nil }
////        let id = impl.findIdentity(for: p, from: impl.rootID!)
////        return Location(impl: impl, id: id, px: p)
////    }
//    func locations(of l: Location) -> SubLocations {
//        guard let d = l.data else { fatalError("Bad location. (past-the-end)") }
//        let cids = impl.children(of: d.id)
//        return SubLocations(impl: impl, data: ())
//    }
//    struct Location {
//        var impl: Impl
//        /// `nil` for past-the-last case.
//        var data: (id: Impl.Identity, px: IndexPath)?
//    }
//    struct SubLocations {
//        var impl: Impl
//        /// `nil` for parent-of-root case.
//        var data: (id: Impl.Identity, px: IndexPath, cids: Impl.IdentityCollection)?
//    }
//}
//public extension PersistentTree.SubLocations {
//    var startIndex: Int {
//        return 0
//    }
//    var endIndex: Int {
//        return impl.rootID == nil ? 0 : 1
//    }
//    subscript(_ i: Int) -> PersistentTree.Location {
//        precondition(i<endIndex,"Index is out of range.")
//        if impl.rootID == nil {
//            // Parent-of-root case.
//            return PersistentTree.Location(impl: impl, data: (impl.rootID!, []))
//        }
//        else {
//            guard let d = data else { fatalError("Bad sublocations.") }
//            let id1 = d.cids[i]
//            let px1 = d.px.appending(i)
//            return PersistentTree.Location(impl: impl, data: (id1,px1))
//        }
//    }
//}


// MARK: Recursive Subtree Navigation
public extension PersistentTree {
    /// Convenient view to navigate subtrees.
    func subtree(at p: IndexPath) -> Subtree {
        precondition(!impl.isEmpty, "Path is out of range.")
        let id = impl.findIdentity(for: p, from: impl.rootID!)
        let s = Subtree(impl: impl, id: id, px: p)
        return s
    }
    struct Subtree {
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
