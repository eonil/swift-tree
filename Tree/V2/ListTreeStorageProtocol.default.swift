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
    mutating func insert(contentsOf t: Tree, at p: IndexPath) {
        precondition(p.count > 0, "You cannot insert a tree at root position.")
        let i = p.first!
        let q = p.dropFirst()
        collection[i].insert(contentsOf: t, at: q)
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

