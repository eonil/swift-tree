////
////  TreeMap.swift
////  Tree
////
////  Created by Henry on 2019/06/23.
////  Copyright © 2019 Eonil. All rights reserved.
////
//
//import Foundation
//import HAMT
//
////protocol TreeMap: Collection {
////    associatedtype Path
////    associatedtype Key: Comparable
////    associatedtype Value
////
////    func index(forKey k: Key) -> Index?
//////    func key(forPath p: Path) -> Key?
//////    func path(forKey k: Key) -> Path?
////    subscript(_ i: Index) -> (key: Key, value: Value) { get }
////
////    func key(forPath p: Path) -> Key?
////    subscript(_ k: Key) -> Value? { get set }
////
////    mutating func insert(_ v: Value, for k: Key, at p: Path)
////    mutating func remove(for k: Key)
////
////    var keys: Keys { get }
////    associatedtype Keys: Collection where Keys.Element == Key
////
////    var values: Values { get }
////    associatedtype Values: Collection where Values.Element == Value
////}
////
/////// An associative array that organizes internal elements in tree shape.
////struct EphemeralTreeMap<Key,Value> {
////    typealias Index = Int
////    typealias Path = IndexPath
////
////    func index(forKey k: Key) -> Index? {
////
////    }
////    func path(forKey k: Key) -> Path? {
////
////    }
////    subscript(_ k: Key) -> Value? {
////
////    }
////    mutating func insert(_ v: Value, for k: Key, at p: Path) {
////
////    }
////    mutating func remove(for k: Key) {
////
////    }
////    mutating func remove(at p: Path) {
////
////    }
////
////    var keys: Keys {
////        let a = [Int:Int]()
////        let b = a[a.startIndex]
////        a[a.startIndex] = 1
////    }
////    struct Keys {
////
////    }
////}
//
//
//
//
//
//
//
//
//
///// - Multi-rooted tree.
///// - Path `[]` is invalid and unaacepted.
//public protocol TreeMap {
//    associatedtype Key: Hashable
//    associatedtype Value
//    associatedtype Path
//
//    init()
//    var isEmpty: Bool { get }
//    var count: Int { get }
//
//    var keys: Keys { get }
//    associatedtype Keys: Collection where Keys.Element == Key
//
//    var values: Values { get }
//    associatedtype Values: Collection where Values.Element == Value
//
//    var root: Key { get }
//    func parent(of k: Key) -> Key?
//    func children(of k: Key) -> Children
//    associatedtype Children: Collection where Children.Element == Key
//
//    subscript(_ k: Key) -> Value? { get }
//
//    mutating func update(_ k: Key, with v: Value)
//    mutating func remove(for k: Key)
//}
//public protocol SetTreeMap: TreeMap {
//    mutating func insert(_ v: Value, for k: Key, in p: [Key])
//    mutating func update(_ k: Key, with v: Value)
//    mutating func remove(for k: Key)
//}
//public protocol ListTreeMap: TreeMap {
//    func key(for idxp: Path) -> Key
//    func key(for idxp: Path, from k: Key) -> Key
//    mutating func replaceSubrange(_ subrange: TreeMapRange<Key,Int>, with newElements: [Value])
//}
//public struct TreeMapLocation<Key,Index> {
//    var parentKey: Key?
//    var childIndex: Int
//}
//public struct TreeMapRange<Key,Index> where Index: Comparable {
//    var parentKey: Key?
//    var childRange: Range<Index>
//}
//
///// - Multi-rooted tree.
///// - Path `[]` is invalid and unaccepted.
//struct TreeMap2<Key,Value> {
//    var impl: ImplPersistentMapBasedTree<Value>
////    typealias Element = (key: Key, value: Value)
////    subscript(_ k: Key) -> Value? {
////    }
//    var subtree: Subtree {
//    }
//    struct Subtree {
//        var impl: ImplPersistentMapBasedTree<Value>
//        var parent: Key
//        var children = [Key]()
//
//        typealias Element = (key: Key, value: Value)
//        var endIndex: Index {
//
//        }
//        subscript(_ k: Key) -> Value? {
//            get {
//
//            }
//        }
//        func subtree(at i: Int) -> Subtree {
//
//        }
//        struct Index {
//
//        }
//    }
//    mutating func insert(_ e: Value, for k: Key, at i: Subtree.Index) {
//
//    }
//}
//
//
///// - Multi-rooted tree.
///// - Path `[]` is invalid and unaccepted.
//struct Tree2<Element> {
//    var impl: ImplPersistentMapBasedTree<Element>
//    //    typealias Element = (key: Key, value: Value)
//    //    subscript(_ k: Key) -> Value? {
//    //    }
//    var subtree: Subtree {
//    }
//    struct Subtree {
//        var impl: ImplPersistentMapBasedTree<Element>
//        var endIndex: Index {
//
//        }
//        func subtree(at i: Int) -> Subtree {
//
//        }
//        struct Index {
//
//        }
//    }
//    mutating func insert(_ e: Element, at i: Subtree.Index) {
//
//    }
//    mutating func remove(at i: Subtree.Index) {
//
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
///// Default implementation of `OT4SnapshotProtocol`.
/////
///// This type provides naive base implementation of default snapshot.
/////
//public struct OT4NaiveSnapshot<Key,Value> where Key: Hashable {
//    public typealias Identity = Key
//    public typealias State = Value
//    public typealias Path = [Identity]
//    public typealias ChildCollection = [Identity]
//
//    internal private(set) var root_id: Key?
//    internal private(set) var state_map = HAMT<Key,Value>()
//    internal private(set) var parent_map = HAMT<Key,Key>()
//    internal private(set) var children_map = HAMT<Key,ChildCollection>()
//
//    public init() {}
//    public var isEmpty: Bool {
//        return root_id == nil
//    }
//    public var count: Int {
//        return state_map.count
//    }
//    public var identities: HAMT<Key,Value>.KeySequence {
//        return state_map.keys
//    }
//
//    public func contains(_ id: Key) -> Bool {
//        return state_map[id] != nil
//    }
//    public func parent(of id: Key) -> Key? {
//        return parent_map[id]
//    }
//    public func children(of id: Key) -> [Key] {
//        return children_map[id]!
//    }
//    public func state(of id: Key) -> Value {
//        return state_map[id]!
//    }
//    public func identity(at idxp: IndexPath) -> Key {
//        return identity(at: idxp, from: root_id!)
//    }
//    private func identity(at idxp: IndexPath, from id: Key) -> Key {
//        switch idxp.count {
//        case 0:
//            return id
//        default:
//            let i = idxp.first!
//            let idxp1 = idxp.dropFirst()
//            let id1 = children(of: id)[i]
//            return identity(at: idxp1, from: id1)
//        }
//    }
//    public func branchability(of id: Key) -> OT4Branchability {
//        return branchables[id] != nil ? .branch : .leaf
//    }
//
//    public mutating func insert(_ st: Value, for id: Key, at idxp: IndexPath) {
//        precondition(state_map[id] == nil)
//        if idxp == [] {
//            precondition(root_id == nil)
//            state_map[id] = st
//            children_map[id] = []
//            branchables[id] = ()
//            root_id = id
//        }
//        else {
//            let i = idxp.last!
//            let pidxp = idxp.dropLast()
//            let pid = identity(at: pidxp)
//            state_map[id] = st
//            parent_map[id] = pid
//            children_map[id] = []
//            children_map[pid, default: []].insert(id, at: i)
//            branchables[id] = ()
//        }
//    }
//    public mutating func update(_ st: Value, for id: Key, as br: OT4Branchability) {
//        precondition(state_map[id] != nil)
//        state_map[id] = st
//        switch br {
//        case .branch:   branchables[id] = ()
//        case .leaf:     branchables[id] = nil
//        }
//    }
//    public mutating func remove(for id: Key) {
//        precondition(state_map[id] != nil)
//        precondition(children_map[id, default: []].count == 0, "You cannot remove node with children. Remove the children first.")
//        if root_id == id {
//            precondition(root_id == id)
//            state_map[id] = nil
//            children_map[id] = nil
//            root_id = nil
//            branchables[id] = nil
//        }
//        else {
//            let idxp = index(of: id)
//            let i = idxp.last!
//            let pidxp = idxp.dropLast()
//            let pid = identity(at: pidxp)
//            state_map[id] = nil
//            parent_map[id] = nil
//            children_map[id] = nil
//            children_map[pid, default: []].remove(at: i)
//            branchables[id] = nil
//        }
//    }
//
//    public static var `default`: OT4NaiveSnapshot {
//        return OT4NaiveSnapshot()
//    }
//}
