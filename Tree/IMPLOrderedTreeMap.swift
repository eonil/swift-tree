//
//  IMPLOrderedTreeMap.swift
//  Tree
//
//  Created by Henry on 2019/06/23.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation
import BTree

/// Internal implementation of OrderedTreeMap.
///
/// Exposes all internals for implementation convenience.
/// Mutators are limited to make correct state.
///
/// - Unordered iteration takes O(n).
/// - DFS iteration takes O(log(n)).
///
struct IMPLOrderedTreeMap<K,V> where K:Comparable {
    let rootKey:K
    private(set) var stateMap = StateMap()
    private(set) var linkageMap = LinkageMap()
    init(root kv:(K,V)) {
        let (k,v) = kv
        rootKey = k
        stateMap[k] = v
        linkageMap[k] = Children()
    }
}
extension IMPLOrderedTreeMap {
    typealias StateMap = Map<K,V>
    typealias LinkageMap = Map<K,Children>
    typealias Children = List<K>
}

// MARK: Tree Access
extension IMPLOrderedTreeMap {
    mutating func replaceState(_ v:V, for k:K) {
        assert(stateMap[k] != nil, "State must exist at this point.")
        stateMap[k] = v
    }
    mutating func replaceSubrange<C>(_ r:Range<Int>, in pk:K, with ts:C) where C:Collection, C.Element == IMPLOrderedTreeMap {
        removeSubrange(r, in: pk)
        insertSubrange(ts, at: r.lowerBound, in: pk)
    }
    /// Please note that this remove all subtrees of existing range.
    mutating func replaceSubrange<C>(_ r:Range<Int>, in pk:K, with kvs:C) where C:Collection, C.Element == (K,V) {
        removeSubrange(r, in: pk)
        insertSubrange(kvs, at: r.lowerBound, in: pk)
    }
    /// This inserts other trees recursively.
    /// - Complexity:
    ///     O(n * log(n)).
    /// - TODO:
    ///     It seems this can be optimized further by using `BTree` directly.
    private mutating func insertSubrange<C>(_ ts:C, at i:Int, in pk:K) where C:Collection, C.Element == IMPLOrderedTreeMap {
        for t in ts {
            for (k,v) in t.stateMap {
                precondition(stateMap.keys.contains(k), "You cannot insert duplicated key.")
                stateMap[k] = v
            }
            for (k,cks) in t.linkageMap {
                linkageMap[k] = cks
            }
        }
        var cks = linkageMap[pk]!
        cks.insert(contentsOf: ts.lazy.map({ $0.rootKey }), at: i)
        linkageMap[pk] = cks
    }
    private mutating func insertSubrange<C>(_ kvs:C, at i:Int, in pk:K) where C:Collection, C.Element == (K,V) {
        for (k,v) in kvs {
            precondition(stateMap[k] == nil, "You cannot insert duplicated key.")
            stateMap[k] = v
            linkageMap[k] = []
        }
        var cks = linkageMap[pk]!
        cks.insert(contentsOf: kvs.lazy.map({$0.0}), at: i)
        linkageMap[pk] = cks
    }
    private mutating func removeSubrange(_ r:Range<Int>, in pk:K) {
        var cks = linkageMap[pk]!
        let childKeysToRemove = cks[r]
        for ck in childKeysToRemove.lazy.reversed() {
            removeRecursively(ck)
        }
        cks.removeSubrange(r)
        linkageMap[pk] = cks
    }
    private mutating func removeRecursively(_ k:K) {
        assert(k != rootKey, "You cannot remove root-key.")
        let cks = linkageMap[k]!
        for ck in cks.lazy.reversed() {
            removeRecursively(ck)
        }
        linkageMap[k] = nil
        stateMap[k] = nil
    }
}

//// MARK: Collection Access
//extension IMPLOrderedTreeMap {
//    typealias Index = StateMap.Index
//    var startIndex: Index {
//        return stateMap.startIndex
//    }
//    var endIndex: Index {
//        return stateMap.endIndex
//    }
//    func index(after i: BTreeIndex<K, V>) -> Index {
//        return stateMap.index(after: i)
//    }
//    func index(before i: BTreeIndex<K, V>) -> Index {
//        return stateMap.index(before: i)
//    }
//    subscript(_ i:Index) -> (K,V) {
//        return stateMap[i]
//    }
//}

//public struct ImplTreeMap<Key,Value> where Key: Comparable {
//    public typealias Identity = Key
//    public typealias State = Value
//    public typealias Path = [Identity]
//    public typealias ChildCollection = [Identity]
//
//    internal private(set) var root_id: Key?
//    internal private(set) var state_map = BTLMap<Key,Value>()
//    internal private(set) var parent_map = BTLMap<Key,Key>()
//    internal private(set) var children_map = BTLMap<Key,ChildCollection>()
//
//    public init() {}
//    public var isEmpty: Bool {
//        return root_id == nil
//    }
//    public var count: Int {
//        return state_map.count
//    }
//    public var identities: BTLMap<Key,Value>.Keys {
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
//    public mutating func insert(_ st: Value, for id: Key, at idxp: IndexPath) {
//        precondition(state_map[id] == nil)
//        if idxp == [] {
//            precondition(root_id == nil)
//            state_map[id] = st
//            children_map[id] = []
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
//        }
//    }
//    public mutating func update(_ st: Value, for id: Key) {
//        precondition(state_map[id] != nil)
//        state_map[id] = st
//    }
//    public mutating func remove(for id: Key) {
//        precondition(state_map[id] != nil)
//        precondition(children_map[id, default: []].count == 0, "You cannot remove node with children. Remove the children first.")
//        if root_id == id {
//            precondition(root_id == id)
//            state_map[id] = nil
//            children_map[id] = nil
//            root_id = nil
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
//        }
//    }
//    ///
//    /// Gets index-path for an identity.
//    ///
//    /// - Complexity:
//    ///     Default implementation uses generic algorithm
//    ///     and takes `<= O(depth * max degree * log n)` time at worst.
//    ///     Override this if you can provide better performance.
//    ///
//    ///     As this method gets called very frequently,
//    ///     performance gain by optimizing this function will be great.
//    ///
//    ///     Overriding this function can make huge difference
//    ///     in some apps. For examples, if your children is strictly
//    ///     append-only, you can use indices as a part of key,
//    ///     and in that case, the function can be implemented
//    ///     in `O(1)` time.
//    ///
//    func index(of id: Identity) -> IndexPath {
//        guard let pid = parent(of: id) else { return [] }
//        let pidxp = index(of: pid)
//        let ids = children(of: pid)
//        let i = ids.firstIndex(of: id)!
//        return pidxp.appending(i)
//    }
//}
//
//extension BTLMap {
//    subscript(_ k: Key, default defv: @autoclosure() -> Value) -> Value {
//        get {
//            return self[k] ?? defv()
//        }
//        set(v) {
//            self[k] = v
//        }
//    }
//}
