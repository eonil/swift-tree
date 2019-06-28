//
//  ListTree.swift
//  Tree
//
//  Created by Henry on 2019/06/28.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation
import BTree

public struct ListTreeStorage<Value>: ListTreeStorageProtocol {
    public var collection = List<ListTree<Value>>()
    public init() {}
}
//public extension ListTreeStorage {
//    typealias Tree = ListTree<Value>
//    subscript(_ p: IndexPath) -> Tree {
//        get {
//            precondition(p.count > 0, "There's no tree at root position.")
//            let i = p.first!
//            let q = p.dropFirst()
//            return collection[i][q]
//        }
//    }
//    mutating func insert(_ t: Tree, at p: IndexPath) {
//        precondition(p.count > 0, "You cannot insert a tree at root position.")
//        let i = p.first!
//        let q = p.dropFirst()
//        collection[i].insert(t, at: q)
//    }
//    mutating func insert(_ v: Value, at p: IndexPath) {
//        insert(Tree(value: v), at: p)
//    }
//    mutating func remove(at p: IndexPath) {
//        precondition(p.count > 0, "You cannot remove tree at root position.")
//        let i = p.first!
//        let q = p.dropFirst()
//        collection[i].remove(at: q)
//    }
//}



/// Tree of lists.
public struct ListTree<Value>: ListTreeProtocol {
    public var value: Value
    public typealias SubCollection = List<ListTree<Value>>
    public var collection = SubCollection()
    public init(value v: Value) {
        value = v
    }
}

//import Foundation
//public extension ListTree {
//    subscript(_ p: IndexPath) -> ListTree {
//        get {
//            switch p.count {
//            case 0:
//                return self
//            default:
//                let i = p.first!
//                let q = p.dropFirst()
//                return collection[i][q]
//            }
//        }
//        set(v) {
//            switch p.count {
//            case 0:
//                self = v
//            default:
//                let i = p.first!
//                let q = p.dropFirst()
//                collection[i][q] = v
//            }
//        }
//    }
//    mutating func insert(_ e: ListTree, at p: IndexPath) {
//        switch p.count {
//        case 0:
//            precondition(p.count > 0, "You cannot insert a new tree at root position.")
//        case 1:
//            let i = p.last!
//            collection.insert(e, at: i)
//        default:
//            let q = p.dropLast()
//            let i = p.last!
//            self[q].collection.insert(e, at: i)
//        }
//    }
//    mutating func insert(_ v: Value, at p: IndexPath) {
//        insert(ListTree(value: v), at: p)
//    }
//    mutating func remove(at p: IndexPath) {
//        switch p.count {
//        case 0:
//            precondition(p.count > 0, "You cannot remove tree at root position.")
//        case 1:
//            let i = p.last!
//            collection.remove(at: i)
//        default:
//            let q = p.dropLast()
//            let i = p.last!
//            self[q].collection.remove(at: i)
//        }
//    }
//}
