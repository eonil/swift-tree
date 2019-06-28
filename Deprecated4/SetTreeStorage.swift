////
////  SetTreeStorage.swift
////  Tree
////
////  Created by Henry on 2019/06/27.
////  Copyright © 2019 Eonil. All rights reserved.
////
//
//public protocol SetTreeStorage {
//    associatedtype Key
//    associatedtype Collection: SetTreeCollection where
//        Collection.Element.Key == Key
//    /// Root collection of this map tree.
//    var collection: Collection { get }
//}
//
//public protocol SetTreeCollection: RandomAccessCollection where Element: SetTree {}
//
//public protocol SetTree {
//    associatedtype Key
//    associatedtype Collection: SetTreeCollection where Collection.Element == Self
//    var key: Key { get }
//    /// Sub-collection.
//    var collection: Collection { get }
//}
//
//
//
//
//
