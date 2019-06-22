//
//  TreeCollection.swift
//  Tree
//
//  Created by Henry on 2019/06/21.
//  Copyright © 2019 Eonil. All rights reserved.
//

/// A collection oganizes internal data in tree-shape.
///
/// Path Base Access
/// --------------
/// You can access internal data using paths.
/// You have to use correct paths when you  insert/remove elements
/// into/from trees.
///
/// Unsorted Iteration
/// ------------------
/// Iterating over `TreeCollection` doesn't have to be sorted.
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
public protocol TreeCollection: Collection {
    /// A read-only sorted view of all paths in this collection.
    /// Paths are sorted in Depth-First-Search order.
    ///
    /// - Complexity:
    ///     Iterating over all paths should take O(n * log(n)).
    var paths: Paths { get }
    associatedtype Paths: Collection where
        Paths.Element == Path

//    /// Subpaths to child nodes of a node at path.
//    func subpaths(of p: Path) -> Subpaths
//    associatedtype Subpaths: Collection where
//        Subpaths.Element == Path

    subscript(_ p: Path) -> Element { get }
    associatedtype Path: Comparable

    func index(for p: Path) -> Index
//    func path(at i: Index) -> Path

    /// Root subtree if available.
    var subtree: Subtree? { get }
    associatedtype Subtree: SubtreeProtocol where
        Subtree.Index == Index,
        Subtree.Path == Path,
        Subtree.Element == Element
}
/// An interface to query tree structure easy and quick.
public protocol SubtreeProtocol {
    var index: Index { get }
    associatedtype Index

    var path: Path { get }
    associatedtype Path

    var element: Element { get }
    associatedtype Element

    var subtrees: SubtreeCollection { get }
    associatedtype SubtreeCollection: RandomAccessCollection where
        SubtreeCollection.Element == Self
}

public protocol MutableTreeCollection: MutableCollection, TreeCollection {
    subscript(_ p: Path) -> Element { get set }
}

public protocol NodeReplaceableTreeCollection: TreeCollection {
    init()
    mutating func replaceSubtree<S>(at p: Path, with s: S) where S: TreeCollection, S.Element == Element
}

//extension NodeReplaceableTreeCollection where
//Path: RandomAccessCollection,
//Path.Element: Comparable {
//
//    /// Replaces consecutive subtrees in tree collection.
//    mutating func replaceSubtrees<C>(_ subrange: Range<Path.Element>, at p: Path, with c: C) where
//        C: Collection, C.Element == Element
//}
//
//import Foundation
//extension NodeReplaceableTreeCollection where Path == IndexPath {
//    mutating func replaceSubtree<S>(at p: Path, with s: S) where S: TreeCollection, S.Element == Element {
//        let i = p.last!
//        let q = p.dropLast()
//        let r = i..<(i+1)
//        replaceSubtrees(r, at: q, with: s)
//    }
//}
