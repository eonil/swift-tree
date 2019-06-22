//
//  DSRefMapTree.swift
//  Tree
//
//  Created by Henry on 2019/06/21.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

protocol DSRefMapTree {
    associatedtype Identity: Hashable
    associatedtype State
    associatedtype IdentityCollection: RandomAccessCollection where
        IdentityCollection.Element == Identity

    var rootID: Identity? { get }
    init()
    func state(of id: Identity) -> State
    mutating func setState(of id: Identity, as s: State)
    func children(of id: Identity) -> IdentityCollection
    mutating func setChildren(of id: Identity, as cs: IdentityCollection)
    subscript(stateOf id: Identity) -> State { get set }
    subscript(childrenOf id: Identity) -> IdentityCollection { get set }

    func findIdentity(for p: IndexPath, from base: Identity) -> Identity
    mutating func insert(_ s: State, at p: IndexPath)
    mutating func remove(at p: IndexPath)
}

extension DSRefMapTree {
    func findIdentity(for p: IndexPath) -> Identity {
        return findIdentity(for: p, from: rootID!)
    }
}
