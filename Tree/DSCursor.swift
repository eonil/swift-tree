//
//  DSCursor.swift
//  Tree
//
//  Created by Henry on 2019/06/21.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

/// Free directional tree walker.
///
/// - Complexity:
///     O(n) to iterate over all elements in tree.
///
/// - Note:
///     Any invalid path will be treated as end-index.
///
struct DSCursor<Element>: Comparable {
    var source: DSPersistentRefMapTree<Element>
    var pathStack = IndexPath()
    var identityStack = ArraySlice<DSIdentity>()
    init(source s: DSPersistentRefMapTree<Element>, path p: IndexPath) {
        source = s
        precondition(s.rootID != nil, "You cannot make cursor on empty source.")
        pathStack.append(p)
        identityStack.append(s.findIdentity(for: p, from: s.rootID!))
    }
    /// Creates cursor for end-index.
    init(source s: DSPersistentRefMapTree<Element>) {
        source = s
    }
    var position: IndexPath {
        return pathStack
    }
    var parent: DSCursor? {
        guard !identityStack.isEmpty else { return nil }
        var x = self
        x.pathStack.removeLast()
        x.identityStack.removeLast()
        return x
    }
    func child(at i: Int) -> DSCursor? {
        guard !identityStack.isEmpty else { return nil }
        let id = identityStack.last!
        let cids = source.children(of: id)
        guard (0..<cids.count).contains(i) else { return nil }
        let cid = cids[i]
        var x = self
        x.pathStack.append(i)
        x.identityStack.append(cid)
        return x
    }
    var firstChild: DSCursor? {
        return child(at: 0)
    }
    var nextSibling: DSCursor? {
        guard !identityStack.isEmpty else { return nil }
        let i = pathStack.last!
        return parent?.child(at: i+1)
    }
    var nextDFS: DSCursor? {
        return child(at: 0) ?? nextSibling ?? parent?.nextSibling
    }

    static func == (lhs: DSCursor, rhs: DSCursor) -> Bool {
        return lhs.position == rhs.position
    }
    static func < (lhs: DSCursor, rhs: DSCursor) -> Bool {
        return lhs.position < rhs.position
    }
}
