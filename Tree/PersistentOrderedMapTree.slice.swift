//
//  PersistentOrderedMapTree.slice.swift
//  Tree
//
//  Created by Henry on 2019/06/27.
//  Copyright © 2019 Eonil. All rights reserved.
//

public extension OrderedMapTreeProtocol {
    func slice(in r: Range<Subtree.Index>, in pk: Key?) -> OrderedMapSlice<Self> {
        return OrderedMapSlice(baseTree: self, parentKey: pk, selectedRange: r)
    }
}
public struct OrderedMapSlice<Base> where
Base: OrderedMapTreeProtocol {
    var baseTree: Base
    var parentKey: Base.Key?
    var selectedRange: Range<Base.Subtree.Index>
}


//public struct OrderedMapSlice<Base>: RandomAccessCollection where Base: OrderedMapTreeProtocol {
//    var parentKey: Base.Key?
//    var selectedRange: Range<Int>
//}
//public extension OrderedMapSlice {
//    var startIndex: Int {
//        return selectedRange.lowerBound
//    }
//    var endIndex: Int {
//        return selectedRange.upperBound
//    }
//    subscript(_ i: Int) -> OrderedMapIndex<Base> {
//        return OrderedMapIndex(parentKey: parentKey, selectedIndex: i)
//    }
//}
//
//public struct OrderedMapIndex<Base> where Base: OrderedMapTreeProtocol {
//    var parentKey: Base.Key?
//    var selectedIndex: Int
//}
//
//public extension OrderedMapTreeProtocol {
//    subscript(_ i: OrderedMapIndex<Self>) -> Element {
//        let s = subtree(for: i.parentKey)
//        let e = s[i.selectedIndex]
//        return (e.key, e.value)
//    }
//}
