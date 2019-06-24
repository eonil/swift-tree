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
    mutating func setState(_ v:V, for k:K) {
        assert(stateMap[k] != nil, "State must exist at this point.")
        stateMap[k] = v
    }
    mutating func replaceSubtrees<C>(_ r:Range<Int>, in pk:K, with ts:C) where C:Collection, C.Element == IMPLOrderedTreeMap {
        removeSubtrees(r, in: pk)
        insertSubtrees(ts, at: r.lowerBound, in: pk)
    }
    /// - TODO:
    ///     We dont need to initialize `IMPLOrderedTreeMap` instance every time...
    mutating func replaceSubrange<C>(_ r:Range<Int>, in pk:K, with kvs:C) where C:Collection, C.Element == (K,V) {
        let ts1 = kvs.map({ IMPLOrderedTreeMap(root: $0) })
        replaceSubtrees(r, in: pk, with: ts1)
    }
    /// This inserts other trees recursively.
    /// - Complexity:
    ///     O(n * log(n)).
    /// - TODO:
    ///     It seems this can be optimized further by using `BTree` directly.
    private mutating func insertSubtrees<C>(_ ts:C, at i:Int, in pk:K) where C:Collection, C.Element == IMPLOrderedTreeMap {
        for t in ts {
            for (k,v) in t.stateMap {
                precondition(stateMap[k] == nil, "You cannot insert duplicated key.")
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
    private mutating func removeSubtrees(_ r:Range<Int>, in pk:K) {
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
