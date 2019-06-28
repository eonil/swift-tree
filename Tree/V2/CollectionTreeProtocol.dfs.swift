//
//  CollectionTreeProtocol.dfs.swift
//  Tree
//
//  Created by Henry on 2019/06/28.
//  Copyright © 2019 Eonil. All rights reserved.
//

public extension CollectionTreeProtocol {
    /// A sequence that iterates all elements in this subtree
    /// in DFS order.
    var dfs: CollectionTreeDFS<Self> {
        return CollectionTreeDFS<Self>(base: self)
    }
}

public struct CollectionTreeDFS<Base>: Sequence where Base: CollectionTreeProtocol {
    var base: Base
}
public extension CollectionTreeDFS {
    typealias Element = Base
    func makeIterator() -> Iterator {
        return Iterator(reversedStack: [base])
    }
    struct Iterator: IteratorProtocol {
        var reversedStack = [Element]()
    }
}
public extension CollectionTreeDFS.Iterator {
    typealias Element = CollectionTreeDFS.Element
    mutating func next() -> Element? {
        guard !reversedStack.isEmpty else { return nil }
        let e = reversedStack.removeFirst()
        reversedStack.insert(contentsOf: e.collection, at: 0)
        return e
    }
}
