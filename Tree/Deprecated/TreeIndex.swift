//
//  TreeIndex.swift
//  PD
//
//  Created by Henry on 2019/06/21.
//

import Foundation

public struct TreeIndex<Tree>: Comparable where Tree: TreeProtocol {
    private var impl: TreeForwardIterator<Tree>
    public init(of x: Tree, at idxp: Tree.Path) {
        impl = TreeForwardIterator(sourceTree: x, at: idxp)
    }
    private init(_ it: TreeForwardIterator<Tree>) {
        impl = it
    }

    /// Returns `nil` for `endIndex`.
    var position: Tree.Path? {
        return impl.navigationStack.last?.path
    }
    var next: TreeIndex {
        var x = self
        _ = x.impl.next()
        return x
    }
    var isEnd: Bool {
        return impl.isEnd
    }
    static var end: TreeIndex {
        return TreeIndex(.end)
    }

    public static func < (lhs: TreeIndex<Tree>, rhs: TreeIndex<Tree>) -> Bool {
        switch (lhs.position, rhs.position) {
        case (nil,nil):         return false // Both are end.
        case (nil,_):           return false // end,non-end.
        case (_,nil):           return true // non-end,end
        case (let a, let b):    return a! < b!
        }
    }
    public static func == (lhs: TreeIndex<Tree>, rhs: TreeIndex<Tree>) -> Bool {
        return lhs.position == rhs.position
    }
}
