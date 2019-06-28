////
////  Tree.swift
////  Tree
////
////  Created by Henry on 2019/06/27.
////  Copyright © 2019 Eonil. All rights reserved.
////
//
//public protocol MapTreeStorage {
//    associatedtype Key
//    associatedtype Value
//    associatedtype Collection: MapTreeCollection where
//        Collection.Element.Key == Key,
//        Collection.Element.Value == Value
//    /// Root collection of this map tree.
//    var collection: Collection { get }
//}
//
//public protocol MapTreeCollection: RandomAccessCollection where Element: MapTree {}
//
//public protocol MapTree {
//    associatedtype Key
//    associatedtype Value
//    associatedtype Collection: MapTreeCollection where Collection.Element == Self
//    var key: Key { get }
//    var value: Value { get }
//    /// Sub-collection.
//    var collection: Collection { get }
//}
//
//public protocol ReplaceableMapTreeStorage: MapTreeStorage {
//    init() 
//    mutating func replace<C>(_ r: Range<Int>, in pk: Key?, with c: C) where
//        C: Swift.Collection,
//        C.Element: MapTree,
//        C.Element.Key == Key,
//        C.Element.Value == Value,
//        C.Element.Collection.Index == Self.Collection.Index
//}
