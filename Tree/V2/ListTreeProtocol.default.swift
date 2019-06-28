//
//  ListTreeProtocol.default.swift
//  Tree
//
//  Created by Henry on 2019/06/28.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

public extension ListTreeProtocol where
SubCollection.Index == Int {
    subscript(_ p: IndexPath) -> Self {
        get {
            switch p.count {
            case 0:
                return self
            default:
                let i = p.first!
                let q = p.dropFirst()
                return collection[i][q]
            }
        }
    }
}
public extension ReplaceableListTreeProtocol where
SubCollection.Index == Int {
    subscript(_ p: IndexPath) -> Self {
        get {
            switch p.count {
            case 0:
                return self
            default:
                let i = p.first!
                let q = p.dropFirst()
                return collection[i][q]
            }
        }
        set(v) {
            switch p.count {
            case 0:
                self = v
            default:
                let i = p.first!
                let q = p.dropFirst()
                collection[i][q] = v
            }
        }
    }
    mutating func insert(contentsOf e: Self, at p: IndexPath) {
        switch p.count {
        case 0:
            precondition(p.count > 0, "You cannot insert a new tree at root position.")
        case 1:
            let i = p.last!
            collection.insert(e, at: i)
        default:
            let q = p.dropLast()
            let i = p.last!
            self[q].collection.insert(e, at: i)
        }
    }
    mutating func insert(_ v: Value, at p: IndexPath) {
        insert(contentsOf: Self(value: v), at: p)
    }
    mutating func remove(at p: IndexPath) {
        switch p.count {
        case 0:
            precondition(p.count > 0, "You cannot remove tree at root position.")
        case 1:
            let i = p.last!
            collection.remove(at: i)
        default:
            let q = p.dropLast()
            let i = p.last!
            self[q].collection.remove(at: i)
        }
    }
}
