//
//  CollectionTreeProtocol.swift
//  Tree
//
//  Created by Henry on 2019/06/28.
//  Copyright © 2019 Eonil. All rights reserved.
//

/// Concept of collection-tree.
///
/// Defines tree of collections.
///
/// This is actually very nice to read tree structure from a storage.
/// Anyway, writing through tree protocol won't be available.
public protocol CollectionTreeProtocol {
    var collection: SubCollection { get }
    associatedtype SubCollection: Collection where
        SubCollection.Element == Self
}

import Foundation
public extension CollectionTreeProtocol where
SubCollection: RandomAccessCollection,
SubCollection.Index == IndexPath.Element {
    func tree(at p: IndexPath) -> Self {
        switch p.count {
        case 0:
            return self
        default:
            let i = p.first!
            let q = p.dropFirst()
            return collection[i].tree(at: q)
        }
    }
}
