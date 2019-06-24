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
///// Represents a subtree of tree.
///// A subtree is a consecutive subset of a tree.
//public struct Subtree<Element>: Sequence, Tree {
//    var impl: PersistentTree<Element>
//    var px: PersistentTree<Element>.Path
//}
//public extension Subtree {
//    typealias Path = IndexPath
//    var isEmpty: Bool {
//        return impl.isEmpty
//    }
//    __consuming func makeIterator() -> Iterator {
//        // Filtering DFS.
//        let c = ImplCursor1(source: impl.impl, path: px)
//        return Iterator(px: px, impl: c)
//    }
//    struct Iterator: IteratorProtocol {
//        let px: Path
//        private(set) var impl: ImplCursor1<Element>?
//    }
//}
//public extension Subtree.Iterator {
//    mutating func next() -> Element? {
//        let s = impl?.state
//        impl = impl?.nextDFS(isIncluded: { p in p.starts(with: px) })
//        return s
//    }
//}
//public extension Subtree {
//    subscript(_ p: IndexPath) -> Element {
//        return impl[px.appending(p)]
//    }
//    func subpaths(of p: Path) -> PersistentTree<Element>.SubPaths {
//        return impl.subpaths(of: px)
//    }
//}
//
////public struct Subtree<Base> where Base: Tree & Collection, Base.Path == IndexPath {
////    var impl: Base
////    var idx: Base.Index
////    var px: Base.Path
////}
////public extension Subtree {
////    var subtrees: Subtrees {
////        return Subtrees(impl: impl, idx: idx, px: px)
////    }
////    struct Subtrees: RandomAccessCollection {
////        var impl: Base
////        var idx: Base.Index
////        var px: Base.Path
////    }
////}
////
////public extension Subtree.Subtrees {
////    subscript(_ i: Int) -> Subtree {
////
////    }
////}
