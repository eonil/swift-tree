//
//  MutableTreeProtocol.extensions.swift
//  PD
//
//  Created by Henry on 2019/06/20.
//

import Foundation

public extension MutableTreeProtocol {
    /// - Note:
    ///     Container node is requird to exist.
    ///     Otherwise, this crashes.
    mutating func insert(_ n: Self, at p: Path) {
        precondition(!p.isEmpty, "You cannot insert at root location.")
        precondition(contains(at: p.dropLast()), "You cannot insert where container node does not exist.")
        let i = p.last!
        let q = p.dropLast()
        self[q].subtrees.insert(n, at: i)
    }
    /// - Note:
    ///     A node must exist at the index.
    mutating func remove(at p: Path) {
        precondition(contains(at: p), "You cannot remove node at wrong index.")
        let i = p.last!
        let q = p.dropLast()
        self[q].subtrees.remove(at: i)
    }
}
public extension MutableTreeProtocol {
    subscript(_ p: Path) -> Element {
        get {
            switch p.count {
            case 0:
                return self
            default:
                let i = p.first!
                let q = p.dropFirst()
                return subtrees[i][q]
            }
        }
        set(v) {
            switch p.count {
            case 0:
                self = v
            default:
                let i = p.first!
                let q = p.dropFirst()
                subtrees[i][q] = v
            }
        }
    }
}
