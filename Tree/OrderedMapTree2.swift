////
////  OrderedMapTree2.swift
////  Tree
////
////  Created by Henry on 2019/06/27.
////  Copyright © 2019 Eonil. All rights reserved.
////
//
////public extension PersistentOrderedMapTree {
////    var asTree2: OrderedMapTree2<Key,Value> {
////        return OrderedMapTree2<Key,Value>(impl: impl, superkey: nil)
////    }
////}
//
//public struct OrderedMapSubtree<Key,Value>: RandomAccessCollection where
//Key: Comparable {
//    private(set) var impl: IMPL
//    private(set) var superkey: Key?
//    private(set) var cachedSubkeys: IMPL.Subkeys
//    typealias IMPL = IMPLPersistentOrderedMapTree<Key,Value>
//
//    init(impl x: IMPL, superkey pk: Key) {
//        impl = x
//        superkey = pk
//        cachedSubkeys = impl.subkeys(for: pk)
//    }
//}
//public extension OrderedMapSubtree {
//    var startIndex: Int {
//        return cachedSubkeys.startIndex
//    }
//    var endIndex: Int {
//        return cachedSubkeys.endIndex
//    }
//    subscript(_ i: Int) -> Element {
//        return Element(impl: impl, superkey: superkey, index: i)
//    }
//    struct Element {
//        private(set) var impl: IMPL
//        private(set) var superkey: Key?
//        private(set) var index: Int
//        var key: Key {
//            return impl.subkeys(for: superkey)[index]
//        }
//        var value: Value {
//            return impl.value(for: key)
//        }
//        var subtrees: OrderedMapSubtree {
//            return OrderedMapTree2(impl: impl, superkey: key)
//        }
//    }
//}
