//
//  ImplPersistentMapBasedTree.swift
//  Tree
//
//  Created by Henry on 2019/06/21.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation
import HAMT
import SBTL

/// Internal storage for tree data.
///
/// This is reference mapping based and likely to provide better data locality
/// than naive recursive tree structure.
///
struct ImplPersistentMapBasedTree<State>:
ImplMapBasedTree,
RandomAccessCollection {
    typealias StateMap = BTLMap<Identity,State>
    typealias ChildrenMap = BTLMap<Identity,Children>
    typealias Children = BTL<Identity>

    private(set) var rootID: Identity?
    private var stateMap = StateMap()
    private var childrenMap = ChildrenMap()

    typealias Identity = ImplIdentity
    init() {}
    /// - Complexity:
    ///     O(log(n)).
    func state(of id: Identity) -> State {
        return stateMap[id]!
    }
    mutating func setState(of id: Identity, as s: State) {
        stateMap[id] = s
    }
    func children(of id: Identity) -> Children {
        return childrenMap[id]!
    }
    mutating func setChildren(of id: Identity, as cs: Children) {
        childrenMap[id] = cs
    }
    subscript(stateOf id: Identity) -> State {
        get { return stateMap[id]! }
        set(v) { stateMap[id] = v }
    }
    subscript(childrenOf id: Identity) -> Children {
        get { return childrenMap[id]! }
        set(v) { childrenMap[id] = v }
    }
}

// MARK: Collection
extension ImplPersistentMapBasedTree {
    typealias Index = StateMap.Index
    var rootIndex: Index {
        return stateMap.keys.firstIndex(of: rootID!)!
    }
    func index(for id: Identity) -> Index {
        return stateMap.keys.firstIndex(of: id)!
    }
    var startIndex: Index {
        return stateMap.startIndex
    }
    var endIndex: Index {
        return stateMap.endIndex
    }
    subscript(_ i: Index) -> State {
        get {
            return stateMap[i].value
        }
        set(v) {
            let id = stateMap[i].key
            setState(of: id, as: v)
        }
    }
}
extension ImplPersistentMapBasedTree {
    /// - Complexity:
    ///     O(n * log(n)).
    ///     Because maxiumu depth is n.
    func findIdentity(for p: IndexPath, from base: Identity) -> Identity {
        precondition(rootID != nil, "Path is out of range.")
        switch p.count {
        case 0:
            return base
        default:
            let i = p.first!
            let q = p.dropFirst()
            let x = children(of: base)[i] // O(log(n))
            return findIdentity(for: q, from: x)
        }
    }
    /// - Complexity:
    ///     O(log(n))
    /// - Returns:
    ///     Children identity list.
    @discardableResult
    mutating func insert(_ s: State, at i: Int, asChildOf pid: ImplIdentity) -> BTL<ImplIdentity> {
        let id = Identity()
        var pcids = children(of: pid)       // O(log(n))
        pcids.insert(id, at: i)             // O(log(n)) because max child count is n, and insertion in B-Tree is log(n).
        setChildren(of: pid, as: pcids)     // O(log(n))
        setState(of: id, as: s)             // O(log(n))
        setChildren(of: id, as: [])         // O(log(n))
        return pcids
    }
    /// - Complexity:
    ///     O(n * log(n)).
    ///     Because maxiumum depth is n.
    mutating func insert(_ s: State, at p: IndexPath) {
        switch p.count {
        case 0:
            precondition(rootID == nil, "Path is out of range.")
            let id = Identity()
            rootID = id
            setState(of: id, as: s) // O(log(n))
            setChildren(of: id, as: []) // O(log(n))
        default:
            precondition(rootID != nil, "Path is out of range.")
            let i = p.last!
            let q = p.dropLast()
            let pid = findIdentity(for: q)      // O(depth * log(n))
            insert(s, at: i, asChildOf: pid)    // O(log(n))
        }
    }
    /// Removes all subtrees from path recursively.
    /// - Complexity:
    ///     O(n * log(n)).
    ///     Because depth <= n.
    mutating func remove(at p: IndexPath) {
        precondition(rootID != nil, "Path is out of range.")
        switch p.count {
        case 0:
            removeRecursively(rootID!)          // O(n * log(n)).
        default:
            let id = findIdentity(for: p)       // O(depth * log(n)).
            removeRecursively(id)               // O(n * log(n)).
        }
    }
    /// - Complexity:
    ///     O(n * log(n)).
    mutating func removeRecursively(_ id: Identity) {
        stateMap[id] = nil                      // O(log(n))
        for cid in childrenMap[id] ?? [] {
            removeRecursively(cid)              // O(n * log(n)) because maximum number of recursive operation is n.
            childrenMap[id] = nil               // O(log(n))
        }
    }
}
