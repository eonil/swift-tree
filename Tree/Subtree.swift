////
////  Subtree.swift
////  Tree
////
////  Created by Henry on 2019/06/23.
////  Copyright © 2019 Eonil. All rights reserved.
////
//
//import Foundation
//
//public struct Subtree<Base> where Base: Tree & Collection, Base.Path == IndexPath {
//    var impl: Base
//    var idx: Base.Index
//    var px: Base.Path
//}
//public extension Subtree {
//    var subtrees: Subtrees {
//        return Subtrees(impl: impl, idx: idx, px: px)
//    }
//    struct Subtrees: RandomAccessCollection {
//        var impl: Base
//        var idx: Base.Index
//        var px: Base.Path
//    }
//}
//
//public extension Subtree.Subtrees {
//    subscript(_ i: Int) -> Subtree {
//        
//    }
//}
