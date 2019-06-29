//
//  CollectionTreeProtocol.paths.swift
//  Tree
//
//  Created by Henry on 2019/06/29.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

public extension CollectionTreeProtocol {
    /// Iterates paths to all elements in this subtree in DFS order.
    /// Returning paths are based from this subtree as root,
    /// therefore, you might need to combine it with super-base
    /// paths.
    ///
    /// You can choose iteration algorithm in one of properties
    /// of this value. For now, there's only `dfs`, but more algorithms
    /// can be added later.
    ///
    var paths: Paths { return Paths(base: self) }
    typealias Paths = CollectionTreePaths<Self>
}
public struct CollectionTreePaths<Base> where Base: CollectionTreeProtocol {
    var base: Base
}
