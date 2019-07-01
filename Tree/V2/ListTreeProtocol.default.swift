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
//    mutating func insert<T>(contentsOf t: T, at p: IndexPath) where
//    T: ListTreeProtocol,
//    T.Value == Value {
//        switch p.count {
//        case 0:
//            precondition(p.count > 0, "You cannot insert a new tree at root position.")
//        case 1:
//            let i = p.last!
//            var t1 = Self(value: t.value)
//            for ct in t.collection {
//                t1.insert(contentsOf: ct, at: t1.collection.count)
//            }
//            collection.insert(t1, at: i)
//        default:
//            let q = p.dropLast()
//            let i = p.last!
//            self[q].collection.insert(contentsOf: t, at: i)
//        }
//    }
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
    mutating func insert<C>(contentsOf es: C, at i: Int, in pp: IndexPath) where C: Collection, C.Element == Self {
        self[pp].collection.insert(contentsOf: es, at: i)
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
    mutating func removeSubrange(_ r: Range<Int>, in pp: IndexPath) {
        self[pp].collection.removeSubrange(r)
    }
}

public extension ReplaceableListTreeProtocol {
    /// Initializes a new tree by copying values and topology of another tree.
    init<T>(_ t: T) where
    T: ReplaceableListTreeProtocol,
    T.Value == Value {
        self = Self(value: t.value)
        for ct in t.collection {
            let ct1 = Self(ct)
            collection.append(ct1)
        }
    }
    /// Initializes a new tree by copying values and topology of another tree.
    init<T>(_ t: T) where
        T: KVLTProtocol,
        Value == (key: T.Key, value: T.Value) {
            self = Self(value: (t.key,t.value))
            for ct in t.collection {
                let ct1 = Self(ct)
                collection.append(ct1)
            }
    }
}
