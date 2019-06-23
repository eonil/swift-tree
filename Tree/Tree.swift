//
//  Tree.swift
//  Tree
//
//  Created by Henry on 2019/06/21.
//  Copyright © 2019 Eonil. All rights reserved.
//

/// A collection that oganizes elements in tree-shape.
///
/// Root-Less
/// ---------
/// `Tree` can be empty. Empty state have no root,
/// and you need to insert root explicitly.
///
/// Path Base Access
/// --------------
/// You can access element using paths.
/// You have to use correct paths when you  insert/remove elements
/// into/from trees. Paths are secondary indices just like keys in dictionaries.
///
/// Unsorted Iteration
/// ------------------
/// Iterating over `Tree` doesn't have to be sorted.
/// You can imagine `Swift.Set` or `Swift.Dictionary`.
/// Iterating over all elements takes *O(n)* time.
///
/// Sorted Path Iteration
/// ---------------------
/// You can iterate sorted paths from `paths` property.
/// Iterating over sorted paths takes *O(n * log(n))* time.
///
/// Subtree Structure Query
/// -----------------------
/// You can query subtree structure recursively
/// via `subtree` property.
///
/// - Complexity:
///     As Swift standard library treats `Dictionary` complexity O(1),
///     I just follow that consumption for all time complexity notations
///     in this library.
///     - Treat hash-table access as O(1).
///     - Persistent variant can take log(n) more time for all operations.
///
public protocol Tree: Collection {
    /// A read-only sorted view of all paths in this collection.
    /// Paths are sorted in Depth-First-Search order.
    ///
    /// - Complexity:
    ///     Iterating over all paths should take O(n).
    ///     Persistent variant can take O(n * log(n)).
    var paths: Paths { get }
    associatedtype Paths: Collection where
        Paths.Element == Path

//    /// Subpaths to child nodes of a node at path.
//    func subpaths(of p: Path) -> Subpaths
//    associatedtype Subpaths: Collection where
//        Subpaths.Element == Path

    associatedtype Path: Comparable

    func index(for p: Path) -> Index
//    func path(at i: Index) -> Path

    /// Gets subtree at path.
    /// - Complexity:
    ///     O(depth).
    ///     Persistent variant can take O(depth * log(n)).
    func subtree(at p: Path) -> Subtree
    associatedtype Subtree: SubtreeProtocol where
        Subtree.Index == Index,
        Subtree.Path == Path,
        Subtree.Element == Element
}
extension Tree where Path: ExpressibleByArrayLiteral {
    /// Root subtree if available.
    var subtree: Subtree? {
        guard !isEmpty else { return nil }
        return subtree(at: [])
    }
    func element(for p: Path) -> Element {
        return self[index(for: p)]
    }
}

/// A tree that can update element without modifying topology.
public protocol MutableTree: Tree {
    subscript(_ p: Path) -> Element { get set }
}

/// A tree that can modify topology.
public protocol NodeReplaceableTree: Tree {
    init()
    mutating func insertSubtree<S>(_ s: S, at p: Path) where S: Tree, S.Element == Element, S.Path == Path
    mutating func replaceSubtree<S>(at p: Path, with s: S) where S: Tree, S.Element == Element, S.Path == Path
    mutating func removeSubtree(at p: Path)
//    mutating func replaceSubtree<S>(at i: Index, with s: S) where S: Tree, S.Element == Element
}
//extension NodeReplaceableTree {
//    mutating func replaceSubtree<S>(for p: Path, with s: S) where S: Tree, S.Element == Element {
//        let i = index(for: p)
//        replaceSubtree(at: i, with: s)
//    }
//}

//extension NodeReplaceableTree where
//Path: RandomAccessCollection,
//Path.Element: Comparable {
//
//    /// Replaces consecutive subtrees in tree collection.
//    mutating func replaceSubtrees<C>(_ subrange: Range<Path.Element>, at p: Path, with c: C) where
//        C: Collection, C.Element == Element
//}
//
//import Foundation
//extension NodeReplaceableTree where Path == IndexPath {
//    mutating func replaceSubtree<S>(at p: Path, with s: S) where S: Tree, S.Element == Element {
//        let i = p.last!
//        let q = p.dropLast()
//        let r = i..<(i+1)
//        replaceSubtrees(r, at: q, with: s)
//    }
//}
