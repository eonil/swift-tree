//
//  TreeWithTreeIndexAsIndex.swift
//  Tree
//
//  Created by Henry on 2019/06/21.
//  Copyright © 2019 Eonil. All rights reserved.
//

/// Trees get automatic collection support
/// if `subtrees` has `TreePath.Element` type index for your convenience.
/// In this automatic support, index type is `TreeIndex`, starting position is `[]`(root),
/// and ending position is `nil`.
/// Iteration will be done in Depth-First-Search order.
///
/// - Complexity:
///     Iteration takes O(n) time.
///
public extension TreeProtocol where Index == TreeIndex<Self> {
    /// - Complexity: `O(1)`
    var startIndex: Index {
        return Index(of: self, at: [])
    }
    /// - Complexity: `O(1)`
    var endIndex: Index {
        return Index.end
    }
    /// Gets next index by Depth-First-Search.
    /// - Complexity: O(1).
    func index(after i: Index) -> Index {
        return i.next
    }
    subscript(_ i: Index) -> Self {
        guard let p = i.position else { fatalError("Index is out of range.") }
        return find(at: p)
    }
    fileprivate func find(at p: Path) -> Self {
        switch p.count {
        case 0:
            return self
        default:
            let i = p.first!
            let q = p.dropFirst()
            return subtrees[i].find(at: q)
        }
    }
}
extension TreeProtocol where Index == TreeIndex<Self> {
    public func index(at p: Path) -> Index {
        return TreeIndex(of: self, at: p)
    }
}

public extension MutableTreeProtocol where Index == TreeIndex<Self> {
    subscript(_ i: Index) -> Self {
        get {
            guard let p = i.position else { fatalError("Index is out of range.") }
            return find(at: p)
        }
        set(v) {
            guard let p = i.position else { fatalError("Index is out of range.") }
            replace(at: p, with: v)
        }
    }
    private mutating func replace(at p: Path, with e: Self) {
        switch p.count {
        case 0:
            self = e
        default:
            let i = p.first!
            let q = p.dropFirst()
            subtrees[i].replace(at: q, with: e)
        }
    }
}
