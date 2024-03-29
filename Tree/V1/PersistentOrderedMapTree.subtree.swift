//
//  PersistentOrderedMapTree.subtree.swift
//  Tree
//
//  Created by Henry on 2019/06/27.
//  Copyright © 2019 Eonil. All rights reserved.
//

public extension PersistentOrderedMapTree {
    /// Root subtree.
    var subtree: Subtree {
        return subtree(for: nil)
    }
    /// A subtree for key.
    /// - Parameter for k:
    ///     `nil` for root subtree.
    ///     Otherwise a key to the subtree.
    func subtree(for k: Key?) -> Subtree {
        return Subtree(impl: impl, key: k)
    }
    struct Subtree: RandomAccessCollection {
        var impl: IMPL
        var key: Key?
        var cachedSubkeys: Subkeys
        init(impl x: IMPL, key k: Key?) {
            impl = x
            key = k
            cachedSubkeys = impl.subkeys(for: k)
        }
    }
}
public extension PersistentOrderedMapTree.Subtree {
    typealias Tree = PersistentOrderedMapTree
    typealias Subtree = Tree.Subtree
    var tree: Tree {
        return Tree(impl: impl)
    }
    func subtree(at i: Int) -> Subtree {
        let sks = impl.subkeys(for: key)
        let sk = sks[i]
        return Subtree(impl: impl, key: sk)
    }
}
// MARK: RandomAccessCollection
public extension PersistentOrderedMapTree.Subtree {
    typealias Index = Int
    typealias Element = (key: Key, value: Value)
    var startIndex: Index {
        return cachedSubkeys.startIndex
    }
    var endIndex: Index {
        return cachedSubkeys.endIndex
    }
    subscript(_ i: Index) -> Element {
        let sk = cachedSubkeys[i]
        let sv = impl.value(for: sk)
        return (sk,sv)
    }
    mutating func append(_ e: Element) {
        insert(e, at: count)
    }
    mutating func insert(_ e: Element, at i: Int) {
        impl.insert((e.key,e.value), at: i, in: key)
        cachedSubkeys = impl.subkeys(for: key)
    }
    /// This also removes subtrees in target range.
    mutating func removeSubrange(_ r: Range<Int>) {
        impl.removeSubtrees(r, in: key)
        cachedSubkeys = impl.subkeys(for: key)
    }
    /// This also removes subtrees at target index.
    mutating func remove(at i: Int) {
        impl.removeSubtree(at: i, in: key)
        cachedSubkeys = impl.subkeys(for: key)
    }
}
