//
//  Tree.swift
//  Tree
//
//  Created by Henry on 2019/06/21.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

public struct Tree<Value>: MutableTreeProtocol {
    public typealias Index = TreeIndex<Tree>
    public typealias Path = TreePath<Array<Tree>.Index>
    public typealias Subtree = Tree

    public var value: Value
    public init(_ v: Value) {
        value = v
    }
    public var subtrees = Array<Tree>()
}
