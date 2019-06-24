//
//  TreeForwardIterator.swift
//  Tree
//
//  Created by Henry on 2019/06/21.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

/// A forward iterator which iterates index-paths and subtrees
/// from designated position for all node in tree in DFS(depth first search) manner.
///
/// This iterator provides O(1) time performance for each iteration.
/// For n items, iteration takes O(n) time and needs O(log(n)) space.
///
/// - Parameter isIncluded:
///     Filters subtree to iterate.
///     If this function returns `false`, whole subtree will be skipped
///     from iteration.
///
public struct TreeForwardIterator<Tree>: IteratorProtocol where
Tree: TreeProtocol {
    public typealias Element = (path: Tree.Path, element: Tree.Element)

    private let isIncluded: (Element) -> Bool
    private(set) var navigationStack = [Element]()

    private func collectNavigationStack(from tree: Tree, to idxp: Tree.Path, into a: inout [Element]) {
        var p = [] as Tree.Path
        var x = tree
        a.append((p,x))
        for i in idxp {
            p.append(i)
            x = x.subtrees[i]
        }
    }

    init(sourceTree x: Tree, at idxp: Tree.Path = [], isIncluded fx: @escaping (Element) -> Bool = { _ in true }) {
        isIncluded = fx
        collectNavigationStack(from: x, to: idxp, into: &navigationStack)
    }
    /// Makes finished iterator.
    private init() {
        isIncluded = { _ in true }
    }
    var isEnd: Bool {
        return navigationStack.isEmpty
    }
    /// - Complexity:
    ///     - Worst Time: O(1) (planned, see TODO.)
    /// - TODO:
    ///     Eliminate subtree copying that prevents actual O(1) time complexity
    ///     and O(log(n)) space complexity.
    ///     Store collection itself instead of collection and make stack
    ///     can iterate over nested collections.
    public mutating func next() -> Element? {
        guard !navigationStack.isEmpty else { return nil }
        let (idxp,node) = navigationStack.removeLast()
        for i in node.subtrees.indices.lazy.reversed() {
            let idxp1 = idxp.appending(i)
            let node1 = node.subtrees[i]
            if isIncluded((idxp1,node1)) {
                navigationStack.append((idxp1,node1))
            }
        }
        return (idxp,node)
    }

    /// Finished iterator.
    /// Provided for comparison.
    static var end: TreeForwardIterator {
        return TreeForwardIterator()
    }
}
