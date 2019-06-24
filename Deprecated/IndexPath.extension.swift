//
//  IndexPath.extension.swift
//  PD
//
//  Created by Henry on 2019/06/21.
//

import Foundation

/// You also can use `IndexPath` as tree paths.
extension IndexPath: TreePathProtocol {}

//extension IndexPath {
//    func up() -> IndexPath? {
//        switch count {
//        case 0:
//            // Root.
//            return nil
//        default:
//            return dropLast()
//        }
//    }
//    func down<Tree>(at i: Int, on source: Tree) -> IndexPath? where Tree: TreeProtocol, Tree.Path == IndexPath {
//        let x = source.index(at: self)
//        return i < x.subtrees.count ? appending(i) : nil
//    }
//    func right<Tree>(on source: Tree) -> IndexPath? where Tree: TreeProtocol, Tree.Path == IndexPath {
//        switch count {
//        case 0:
//            // Root. No right sibling.
//            return nil
//        default:
//            let i = last! + 1
//            return up()?.down(at: i, on: source)
//        }
//    }
//    func nextDFS<Tree>(on source: Tree) -> IndexPath? where Tree: TreeProtocol, Tree.Path == IndexPath {
//        return down(at: 0, on: source)
//            ?? right(on: source)
//            ?? { () -> IndexPath? in
//                var x = self as IndexPath?
//                while x != nil {
//                    if let z = x?.up()?.right(on: source) {
//                        return z
//                    }
//                    x = x?.up()
//                }
//                return nil
//            }()
//    }
//}
