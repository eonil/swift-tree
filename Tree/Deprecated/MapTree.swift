//
//  MapTree.swift
//  Tree
//
//  Created by Henry on 2019/06/21.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

/// **PREMATURE OPTIMIZATION IS THE ROOT OF ALL EVIL**

///// A tree implemented using associative array.
/////
///// Default tree implementation `Tree` is simple and easy,
///// but all each subtree nodes are distributed over random location of memory,
///// therefore has bad data locality.
///// This type tries to solve that issue by placing multiple nodes into consecutive memory space.
/////
///// - Note:
/////     This is a specialized optimization solution. It's hard to implement this kind of
/////     solution to follow generic interface all efficiently.
/////
//public struct MapTree<Identity,State> where Identity: Hashable {
//    private var rootID: Identity?
//    private var stateMap = [Identity: State]()
//    private var childrenMap = [Identity: [Identity]]()
//
//    public init() {}
//    public func state(of id: Identity) -> State {
//        return stateMap[id]!
//    }
//    public mutating func setState(of id: Identity, as s: State) {
//        stateMap[id] = s
//    }
//    public func children(of id: Identity) -> [Identity] {
//        return childrenMap[id]!
//    }
//    mutating func setChildren(of id: Identity, as cs: [Identity]) {
//        childrenMap[id] = cs
//    }
//
//    /// A read-only view in recursive tree protocol. (`TreeProtocol`)
//    public var tree: Node? {
//        guard let id = rootID else { return nil }
//        return Node(impl: self, identity: id)
//    }
//
//    /// A `TreeProtocol` type view of `MapTree`.
//    public struct Node: TreeProtocol {
//        private(set) var impl: MapTree
//        private(set) var identity: Identity
//
//        public typealias Index = TreeIndex<Self>
//        public typealias Path = TreePath<Int>
//
//        init(impl x: MapTree, identity id: Identity) {
//            impl = x
//            identity = id
//        }
//        public var state: State {
//            return impl.state(of: identity)
//        }
//        public var subtrees: Subnodes {
//            get { Subnodes(impl: impl, children: impl.children(of: identity)) }
//        }
//    }
//    public struct Subnodes: RandomAccessCollection {
//        private(set) var impl: MapTree
//        private(set) var children: [Identity]
//
//        public init() {
//            impl = MapTree()
//            children = []
//        }
//        init(impl x: MapTree, children cs: [Identity]) {
//            children = cs
//            impl = x
//        }
//        public var startIndex: Int { children.startIndex }
//        public var endIndex: Int { children.endIndex }
//        public subscript(_ i: Int) -> Node {
//            get { Node(impl: impl, identity: children[i]) }
//        }
//    }
//}
//
////public protocol MapTreeValueProtocol {
////    associatedtype Identity: Hashable
////    var identity: Identity { get }
////}
////
////public struct MapTree<Value>:
////TreeProtocol,
////RandomAccessTreeProtocol,
////MutableTreeProtocol,
////RangeReplaceableTreeProtocol where
////Value: MapTreeValueProtocol {
////    private var impl = MapTreeImpl<MapTree>()
////    private var
////    public init() {}
////}
////public struct MapTreeSubtreeCollection<Value>:
////RandomAccessCollection where
////Value: MapTreeValueProtocol {
////    fileprivate var impl: MapTreeImpl<MapTree<Value>>
////}
////
////private struct MapTreeImpl<Element> where Element: MapTreeValueProtocol {
////    private var stateMap = [Identity: Element]()
////    private var childrendMap = [Identity: [Identity]]()
////
////    typealias Identity = Element.Identity
////    typealias State = Element
////
////    func contains(_ id: Identity) -> Bool {
////        return stateMap[id] != nil
////    }
////    func state(of id: Identity) -> State {
////        return stateMap[id]!
////    }
////    func children(of id: Identity) -> [Identity] {
////        return childrendMap[id] ?? []
////    }
////
////
////}
