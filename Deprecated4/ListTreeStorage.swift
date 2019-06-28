////
////  ListTreeStorage.swift
////  Tree
////
////  Created by Henry on 2019/06/27.
////  Copyright © 2019 Eonil. All rights reserved.
////
//
//public protocol ListTreeStorage {
//    associatedtype Value
//    associatedtype Collection: ListTreeCollection where
//        Collection.Element.Value == Value
//    /// Root collection of this map tree.
//    var collection: Collection { get }
//}
//
//public protocol ListTreeCollection: RandomAccessCollection where Element: ListTree {}
//
//public protocol ListTree {
//    associatedtype Value
//    associatedtype Collection: ListTreeCollection where Collection.Element == Self
//    var value: Value { get }
//    /// Sub-collection.
//    var collection: Collection { get }
//}
//
//
//
//
//
