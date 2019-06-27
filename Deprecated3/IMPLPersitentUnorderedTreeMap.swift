//
//  IMPLPersitentUnorderedTreeMap.swift
//  Tree
//
//  Created by Henry on 2019/06/23.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation
import BTree

/// Internal implementation of persistent and unordered tree-map.
///
/// Exposes all internals for implementation convenience.
/// Mutators are limited to make correct state.
///
/// - Unordered iteration takes O(n).
/// - DFS iteration takes O(log(n)).
///
struct IMPLPersitentUnorderedTreeMap<K,V> where K:Comparable {
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
extension IMPLPersitentUnorderedTreeMap {
    typealias StateMap = Map<K,V>
    typealias LinkageMap = Map<K,Children>
    typealias Children = SortedSet<K>
}

// MARK: Tree Access
extension IMPLPersitentUnorderedTreeMap {
    mutating func setState(_ v:V, for k:K) {
        assert(stateMap[k] != nil, "State must exist at this point.")
        stateMap[k] = v
    }
    mutating func replaceSubtree(_ k:K, in pk:K, with s:IMPLPersitentUnorderedTreeMap) {
        removeSubtree(k, in: pk)
        insertSubtree(s, in: pk)
    }
    mutating func insertSubtree(_ s:IMPLPersitentUnorderedTreeMap, in pk:K) {
        for (k,v) in s.stateMap {
            precondition(stateMap[k] == nil, "You cannot insert duplicated key.")
            stateMap[k] = v
        }
        for (k,cks) in s.linkageMap {
            linkageMap[k] = cks
        }
        var cks = linkageMap[pk]!
        cks.insert(s.rootKey)
        linkageMap[pk] = cks
    }
    mutating func removeSubtree(_ k:K, in pk:K) {
        removeRecursively(k)
        var cks = linkageMap[pk]!
        cks.remove(k)
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
