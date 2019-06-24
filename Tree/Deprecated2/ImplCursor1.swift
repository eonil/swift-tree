//
//  IMPLCursor.swift
//  Tree
//
//  Created by Henry on 2019/06/21.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

/// Free directional tree walker.
///
/// - Complexity:
///     O(n * log(n)) to iterate over all elements in tree.
///
/// - Note:
///     Any invalid path will be treated as end-index.
///
@available(*,deprecated: 0)
struct ImplCursor1<Element>: Comparable {
    var source: ImplPersistentMapBasedTree<Element>
    var pathStack = IndexPath()
    var identityStack = ArraySlice<ImplIdentity>()
    init(source s: ImplPersistentMapBasedTree<Element>, path p: IndexPath) {
        source = s
        precondition(s.rootID != nil, "You cannot make cursor on empty source.")
        pathStack.append(p)
        identityStack.append(s.findIdentity(for: p, from: s.rootID!))
    }
    /// Creates cursor for end-index.
    init(source s: ImplPersistentMapBasedTree<Element>) {
        source = s
    }
    var position: IndexPath {
        return pathStack
    }
    /// Returns state at current position.
    /// `nil` for end-index position.
    /// - Complexity:
    ///     O(log(n)).
    var state: Element? {
        guard let id = identityStack.last else { return nil }
        return source.state(of: id)
    }
    /// - Complexity:
    ///     O(1).
    var parent: ImplCursor1? {
        guard !identityStack.isEmpty else { return nil }
        var x = self
        x.pathStack.removeLast()            // O(1)
        x.identityStack.removeLast()        // O(1)
        return x
    }
    /// - Complexity:
    ///     O(log(n)).
    func child(at i: Int) -> ImplCursor1? {
        guard !identityStack.isEmpty else { return nil }
        let id = identityStack.last!
        let cids = source.children(of: id)  // O(log(n))
        guard (0..<cids.count).contains(i) else { return nil }
        let cid = cids[i]                   // O(log(n))
        var x = self
        x.pathStack.append(i)               // O(1) armortized.
        x.identityStack.append(cid)         // O(1) armortized.
        return x
    }
    /// - Complexity:
    ///     O(log(n)).
    var firstChild: ImplCursor1? {
        return child(at: 0)
    }
    /// - Complexity:
    ///     O(log(n)).
    var nextSibling: ImplCursor1? {
        guard !identityStack.isEmpty else { return nil }
        let i = pathStack.last!
        return parent?.child(at: i+1)
    }
    /// - Complexity:
    ///     O(log(n)).
    var nextDFS: ImplCursor1? {
        return child(at: 0) ?? nextSibling ?? parent?.nextSibling
    }
    func nextDFS(isIncluded: (IndexPath) -> Bool) -> ImplCursor1? {
        guard var n = nextDFS else { return nil }
        while !isIncluded(n.position) {
            guard let n1 = n.nextDFS else { return nil }
            n = n1
        }
        return n
    }

    static func == (lhs: ImplCursor1, rhs: ImplCursor1) -> Bool {
        return lhs.position == rhs.position
    }
    static func < (lhs: ImplCursor1, rhs: ImplCursor1) -> Bool {
        return lhs.position < rhs.position
    }
}
