//
//  IMPLPersistentOrderedMapTree.swift
//  Tree
//
//  Created by Henry on 2019/06/26.
//  Copyright © 2019 Eonil. All rights reserved.
//

import BTree

/// Internal implementation of explicitly ordered, persistent and root-less tree-map.
///
/// This is a minimum protection for nicer interface `PersistentORderedRootlessMapTree`
/// against all dirty implementation details.
///
/// Exposes all internals for implementation convenience.
/// Mutators are limited to make correct state.
///
/// - Unordered iteration takes O(n).
/// - DFS iteration takes O(log(n)).
///
/// Root-Less
/// ---------
/// This type has root-less design. (a.k.a. implicitly rooted or multi-rooted)
/// There's no root node, and no value will be stored for root position.
/// You can use `nil` to insert/remove subkeys of root position.
///
struct IMPLPersistentOrderedMapTree<K,V> where
K:Comparable {
    private var subkeysMap = SubkeysMap()
    private var valueMap = ValueMap()
    typealias Index = ValueMap.Index
    typealias Element = (K,V)
    typealias SubkeysMap = Map<Alt<K>,Subkeys>
    typealias Subkeys = List<K>
    typealias ValueMap = Map<K,V>
    typealias Alt = IMPLAlternativeOptional
    init() {
        subkeysMap[Alt(nil)] = []
    }
}
// MARK: Read
extension IMPLPersistentOrderedMapTree {
    var isEmpty: Bool {
        return valueMap.isEmpty
    }
    var count: Int {
        return valueMap.count
    }
    var startIndex: Index {
        return valueMap.startIndex
    }
    var endIndex: Index {
        return valueMap.endIndex
    }
    func index(after i: Index) -> Index {
        return valueMap.index(after: i)
    }
    /// - Note:
    ///     Writing back a new element for an index
    ///     requires look-up for a key in subkey list,
    ///     and that cannot be done in O(1) (or O(log(n)) in persistent variant).
    ///     Therefore, index setter cannot be implemented.
    subscript(_ i:Index) -> Element {
        return valueMap[i]
    }
    func value(for k:K) -> V {
        guard let v = valueMap[k] else { fatalError("Supplied key is not in this tree.") }
        return v
    }
    func subkeys(for k:K?) -> Subkeys {
        return subkeysMap[Alt(k)]!
    }
    /// - Complexity: O(log(`count`))
    func firstIndex(of k:K) -> Index? {
        guard let offset = valueMap.offset(of: k) else { return nil }
        let index = valueMap.index(ofOffset: offset)
        return index
    }
}
// MARK: Write
extension IMPLPersistentOrderedMapTree {
    mutating func setValue(_ v:V, for k:K) {
        precondition(valueMap[k] != nil, "Supplied key is not in this tree.")
        valueMap[k] = v
    }
    mutating func insert(_ e:Element, at i:Int, in pk:K?) {
        guard var ks = subkeysMap[Alt(pk)] else { fatalError("The key is not a part of this tree.") }
        precondition(valueMap[e.0] == nil, "Supplied key is already in tree.")
        let (k,v) = e
        ks.insert(k, at: i)
        valueMap[k] = v
        subkeysMap[Alt(k)] = []
        subkeysMap[Alt(pk)] = ks
    }
    mutating func insert<C>(contentsOf es:C, at i:Int, in pk:K?) where C:Collection, C.Element == Element {
        guard var ks = subkeysMap[Alt(pk)] else { fatalError("The key is not a part of this tree.") }
        ks.insert(contentsOf: es.lazy.map({ $0.0 }), at: i)
        for (k,v) in es {
            precondition(valueMap[k] == nil, "Supplied key is already in tree.")
            subkeysMap[Alt(k)] = []
            valueMap[k] = v
        }
        subkeysMap[Alt(pk)] = ks
    }
    /// All keys in all trees must be unique.
    mutating func insertSubtree(_ k:K, of t:IMPLPersistentOrderedMapTree, at i:Int, in pk:K?) {
        guard var ks = subkeysMap[Alt(pk)] else { fatalError("The key is not a part of this tree.") }
        precondition(
            !valueMap.keys.contains(k),
            "Supplied tree contains one or more duplicated keys.")
        let v = t.valueMap[k]!
        let sks = t.subkeysMap[Alt(k)]!
        for (si,sk) in sks.enumerated() {
            insertSubtree(sk, of: t, at: si, in: k)
        }
        valueMap[k] = v
        subkeysMap[Alt(k)] = sks
        ks.insert(k, at: i)
        subkeysMap[Alt(pk)] = ks
    }
    /// Merges another tree.
    /// All keys in all trees must be unique. 
    mutating func merge(_ t: IMPLPersistentOrderedMapTree) {
        for k in t.valueMap.keys {
            precondition(
                !valueMap.keys.contains(k),
                "There're some duplicated keys in supplied tree.")
        }
        valueMap = valueMap.merging(t.valueMap)
        subkeysMap = subkeysMap.merging(t.subkeysMap)
    }
    mutating func removeSubtrees(_ r:Range<Int>, in pk:K?) {
        guard var ks = subkeysMap[Alt(pk)] else { fatalError("The key is not a part of this tree.") }
        for k in ks[r] {
            removeAllDescendantsRecursively(for: k)
            valueMap[k] = nil
            subkeysMap[Alt(k)] = nil
        }
        ks.removeSubrange(r)
        subkeysMap[Alt(pk)] = ks
    }
    mutating func removeSubtree(at i:Int, in pk:K?) {
        guard var ks = subkeysMap[Alt(pk)] else { fatalError("The key is not a part of this tree.") }
        let k = ks[i]
        removeAllDescendantsRecursively(for: k)
        valueMap[k] = nil
        subkeysMap[Alt(k)] = nil
        ks.remove(at: i)
        subkeysMap[Alt(pk)] = ks
    }
    /// Removes all descendants except target node itself.
    private mutating func removeAllDescendantsRecursively(for k:K?) {
        guard let sks = subkeysMap[Alt(k)] else { fatalError("The key is not a part of this tree.") }
        for sk in sks {
            removeAllDescendantsRecursively(for: sk)
            valueMap[sk] = nil
            subkeysMap[Alt(sk)] = nil
        }
        subkeysMap[Alt(k)] = []
    }
    mutating func removeAll() {
        subkeysMap.removeAll()
        valueMap.removeAll()
    }
}

extension IMPLPersistentOrderedMapTree {
    /// - Complexity:
    ///     O(n * log(n)).
    func mapValues<X>(_ fx: (V) -> X) -> IMPLPersistentOrderedMapTree<K,X> {
        var s = IMPLPersistentOrderedMapTree<K,X>()
        s.subkeysMap = subkeysMap
        for (k,v) in valueMap {
            s.valueMap[k] = fx(v)
        }
        return s
    }
}
