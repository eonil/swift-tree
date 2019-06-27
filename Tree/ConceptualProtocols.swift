////
////  CollectionTree.swift
////  Tree
////
////  Created by Henry on 2019/06/27.
////  Copyright © 2019 Eonil. All rights reserved.
////
//
///// A tree of collections.
/////
///// In this tree, each node of a tree is collection.
///// An element in a collection owns subcollection recursively.
///// Inserting/removing an element implicily insert/remove subcollections too.
/////
///// - You can access all elements in the tree at this collection interface.
///// - You can access each subtree level collections using `subcollection` function.
/////
//public protocol CollectionTree: Collection {
//    associatedtype SubCollection: CollectionTreeSubCollection
//    /// Gets root subcollection.
//    var subcollection: SubCollection { get }
//    /// Gets subcollection for arbitrary element at index.
//    func subcollection(for: Index) -> SubCollection
//}
//public protocol CollectionTreeSubCollection: Collection {
//    func subcollection(for: Index) -> Self
//}
//
//
//
//// MARK: List Trees
//
//public typealias ListTree = OrderedSetTree
//
//
//
//// MARK: Set Trees
//
///// A `CollectionTree` where element's subcollections are sets.
/////
///// This is still an abstract concept, and you are supposed to use
///// one of concrete protocols -- `UnorderedSetTree` or `OrderedSetTree`.
//public protocol SetTree: CollectionTree {
//    func subcollection(for: Element) -> SubCollection
//}
//
///// A collection tree where each element have a set as its own subcollection.
//public protocol UnorderedSetTree: SetTree {
//}
//
///// A collection tree where each element have a set as its own subcollection.
//public protocol OrderedSetTree: SetTree {
//}
//
//
//
//// MARK: Map Trees
//
///// A `CollectionTree` where element's subcollections are map (associative array).
/////
///// This is still an abstract concept, and you are supposed to use
///// one of concrete protocols -- `UnorderedMapTree` or `OrderedMapTree`.
//public protocol MapTree: CollectionTree {
//    associatedtype Key
//    associatedtype Value
//    subscript(_:Key) -> Value { get }
//    func subcollection(for: Key) -> SubCollection
//}
//
///// A `CollectionTree` where element's subcollections are map (associative array).
/////
///// Elements in subcollections are not ordered like `[Key:Value]`.
/////
//public protocol UnorderedMapTree: MapTree {
//}
//
///// A `CollectionTree` where element's subcollections are ordered map (associative array).
/////
///// Elements in subcollections are explicitly ordered like `[(key: Key, value: Value)]`.
///// You can find values by keys at whole tree level, but not at subcollection level
///// because it's inefficient.
//public protocol OrderedMapTree: MapTree {
//}
