//
//  CollectionTreeProtocol.paths.dfs.swift
//  Tree
//
//  Created by Henry on 2019/06/29.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

public extension CollectionTreePaths {
    /// A sequence that iterates all paths to elements in this subtree
    /// in DFS order.
    var dfs: DFS {
        return DFS(base: base)
    }
    typealias DFS = CollectionTreePathsDFS<Base>
}

public struct CollectionTreePathsDFS<Base>: Sequence where Base: CollectionTreeProtocol {
    var base: Base
}
public extension CollectionTreePathsDFS {
    typealias Element = Iterator.Element
    func makeIterator() -> Iterator {
        return Iterator(reversedStack: [(path: [], tree: base)])
    }
    struct Iterator: IteratorProtocol {
        var reversedStack = [Element]()
    }
}
public extension CollectionTreePathsDFS.Iterator {
    typealias Element = (path: IndexPath, tree: Base)
    mutating func next() -> Element? {
        guard !reversedStack.isEmpty else { return nil }
        let (p,e) = reversedStack.removeFirst()
        let cpes = e.collection.enumerated().map({ (i,ce) in (p.appending(i),ce) })
        reversedStack.insert(contentsOf: cpes, at: 0)
        return (p,e)
    }
}
