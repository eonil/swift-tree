//
//  ListTreeStorageProtocol.default.swift
//  Tree
//
//  Created by Henry on 2019/06/28.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

public extension ListTreeStorageProtocol where
Collection.Index == Int {
    subscript(_ p: IndexPath) -> Tree {
        get {
            precondition(p.count > 0, "There's no tree at root position.")
            let i = p.first!
            let q = p.dropFirst()
            return collection[i][q]
        }
    }
}
public extension ReplaceableListTreeStorageProtocol where
Collection.Index == Int {
    subscript(_ p: IndexPath) -> Tree {
        get {
            precondition(p.count > 0, "There's no tree at root position.")
            let i = p.first!
            let q = p.dropFirst()
            return collection[i][q]
        }
        set(v) {
            precondition(p.count > 0, "There's no tree at root position.")
            let i = p.first!
            let q = p.dropFirst()
            collection[i][q] = v
        }
    }
//    mutating func insert<T>(contentsOf t: T, at p: IndexPath) where
//    T: ListTreeProtocol,
//    T.Value == Value {
//        precondition(p.count > 0, "You cannot insert a tree at root position.")
//        let i = p.last!
//        let q = p.dropFirst()
//        let t1 = Tree(value: t.value)
//        t1.insert(contentsOf: <#T##ReplaceableListTreeProtocol#>, at: <#T##IndexPath#>)
//        collection.insert(t1, at: i)
//    }
    mutating func insert(contentsOf t: Tree, at p: IndexPath) {
        switch p.count {
        case 0: fatalError("You cannot insert a tree at root position.")
        case 1: collection.insert(t, at: p.last!)
        default:
            let i = p.first!
            let q = p.dropFirst()
            collection[i].insert(contentsOf: t, at: q)
        }
    }
    mutating func insert(_ v: Value, at p: IndexPath) {
        insert(contentsOf: Tree(value: v), at: p)
    }
    mutating func remove(at p: IndexPath) {
        precondition(p.count > 0, "You cannot remove tree at root position.")
        let i = p.first!
        let q = p.dropFirst()
        collection[i].remove(at: q)
    }
}

public extension ReplaceableListTreeStorageProtocol {
    /// Initializes a new tree by copying values and topology of another tree.
    init<T>(_ t: T) where
    T: ReplaceableListTreeStorageProtocol,
    T.Tree.Value == Tree.Value {
        self = Self()
        for ct in t.collection {
            let ct1 = Tree(value: ct.value)
            collection.append(ct1)
        }
    }
}
