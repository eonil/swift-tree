//
//  DSPersistentRefMapTree.swift
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
struct DSPersistentRefMapTree<State>:
DSRefMapTree,
RandomAccessCollection {
    typealias StateMap = BTLMap<Identity,State>
    typealias ChildrenMap = BTLMap<Identity,Children>
    typealias Children = BTL<Identity>

    private(set) var rootID: Identity?
    private var stateMap = StateMap()
    private var childrenMap = ChildrenMap()

    typealias Identity = DSIdentity
    init() {}
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
extension DSPersistentRefMapTree {
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
extension DSPersistentRefMapTree {
    func findIdentity(for p: IndexPath, from base: Identity) -> Identity {
        precondition(rootID != nil, "Path is out of range.")
        switch p.count {
        case 0:
            return base
        default:
            let i = p.first!
            let q = p.dropFirst()
            let x = children(of: base)[i]
            return findIdentity(for: q, from: x)
        }
    }
    mutating func insert(_ s: State, at p: IndexPath) {
        switch p.count {
        case 0:
            precondition(rootID == nil, "Path is out of range.")
            let id = Identity()
            rootID = id
            setState(of: id, as: s)
            setChildren(of: id, as: [])
        default:
            precondition(rootID != nil, "Path is out of range.")
            let id = Identity()
            let i = p.last!
            let q = p.dropLast()
            let pid = findIdentity(for: q)
            var pcids = children(of: pid)
            pcids.insert(id, at: i)
            setChildren(of: pid, as: pcids)
            setState(of: id, as: s)
            setChildren(of: id, as: [])
        }
    }
    /// This removes all subtrees recursively
    mutating func remove(at p: IndexPath) {
        precondition(rootID != nil, "Path is out of range.")
        switch p.count {
        case 0:
            removeRecursively(rootID!)
        default:
            let id = findIdentity(for: p)
            removeRecursively(id)
        }
    }
    private mutating func removeRecursively(_ id: Identity) {
        stateMap[id] = nil
        for cid in childrenMap[id] ?? [] {
            removeRecursively(cid)
            childrenMap[id] = nil
        }
    }
}
