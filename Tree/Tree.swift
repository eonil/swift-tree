//
//  Tree.swift
//  Tree
//
//  Created by Henry on 2019/06/21.
//  Copyright © 2019 Eonil. All rights reserved.
//

/// A container that oganizes elements in tree-shape.
///
/// Non-`Collection` Type
/// --------------------
/// A `Tree` is not a `Collection` type automatically.
/// An implementation of `Tree` can also implement `Collection`,
/// but it's not required.
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
///     - Persistent variant can take log(n) more time for all each operations.
public protocol Tree: Sequence {
    var isEmpty: Bool { get }
    associatedtype Element
    /// Gets an element at O(depth) time.
    subscript(_ p: Path) -> Element { get }
    /// A read-only sorted view of all paths in this collection.
    ///
//    /// Paths are sorted in Depth-First-Search order.
//    /// This is an analogue to `Collection.Index`.
//    /// - Complexity:
//    ///     Iterating over all paths should take O(n).
//    ///     Persistent variant can take O(n * log(n)).
//    var paths: Paths { get }
    func subpaths(of p: Path) -> SubPaths
    /// Indicates a position in a tree.
    /// - Note:
    ///     Some implementations with special `Path` type
    ///     potentially can provide better performance.
    ///     For example, some datastructures like Heap uses
    ///     Complete Binary Tree and can use simple `Int` index
    ///     without sacrificing navigatability. In that case,
    ///     path-based operations can provide O(1) time.
    associatedtype Path: Comparable
    associatedtype Paths: Collection where Paths.Element == Path
    associatedtype SubPaths: RandomAccessCollection where SubPaths.Element == Path

////    var locations: Locations { get }
////    associatedtype Locations: Collection where Locations.Element == Location
//
//    var startLocation: Location { get }
//    var endLocation: Location { get }
//    func locations(of: Location) -> SubLocations
//    /// Root location.
//    var location: Location? { get }
//    var locations: Locations { get }
//    associatedtype Locations
//    /// Gets an element at location in O(depth).
//    subscript(_: Location) -> Element { get }
//    /// An analogue to `Collection.Index`.
//    /// Just like `Collection.Index`, this provides access to an element in O(1) time.
//    associatedtype Location
//    associatedtype SubLocations: LocationCollectionProtocol

//    func location(for p: Path) -> Location?

//    /// Gets subtree at path.
//    /// - Complexity:
//    ///     O(depth).
//    ///     Persistent variant can take O(depth * log(n)).
//    func subtree(at p: Path) -> Subtree?
//    associatedtype Subtree: SubtreeProtocol
//    Subtree.Path == Path,
//    Subtree.Element == Element
}
//public protocol TreeLocation {
//    var sublocations: Sublocations { get }
//    associatedtype Sublocations: RandomAccessCollection where
//        Sublocations.Element == Self
//}

//extension Tree where Path: ExpressibleByArrayLiteral {
//    /// Root subtree if available.
//    var subtree: Subtree? {
//        guard !isEmpty else { return nil }
//        return subtree(at: [])
//    }
////    /// Root subtree if available.
////    var location: Location? {
////        guard !isEmpty else { return nil }
////        return location(for: [])
////    }
//}

//protocol LocationCollectionProtocol {
//    associatedtype Location
//    var startLocation: Location { get }
//    var endLocation: Location { get }
//}


///// A tree that can be queried without recursing locations.
//public protocol RandomAccessTree: Tree where
//Location: Collection,
//Location.Element == SubLocations.Index {
//}

/// A tree that can update element without modifying topology.
public protocol MutableTree: Tree {
    subscript(_ path: Path) -> Element { get set }
}

/// A tree that can modify topology.
///
/// This is analogue to `RangeReplaceableCollection` in tree.
/// As like `RangeReplaceableCollection` can handle multiple
/// elements at once, this also provides ability to handle multiple subtrees
/// at once. Also as like `RangeReplaceableCollection` can
/// handle only single organized(consecutive) unit, this also can handle
/// single organized unit(subtree).
///
/// - Note:
///     Implementation should provide a way to make new paths
///     for insert operation. Otherwise, there's no way to insert
///     new subtree.
public protocol NodeReplaceableTree: Tree {
    init()
    mutating func insert(_: Element, at: Path)
    mutating func insertSubtree<S>(_: S, at: Path) where S: Tree, S.Element == Element, S.Path == Path
    mutating func replaceSubtree<S>(at: Path, with s: S) where S: Tree, S.Element == Element, S.Path == Path
    mutating func removeSubtree(at: Path)
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
