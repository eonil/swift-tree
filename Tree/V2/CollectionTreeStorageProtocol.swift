//
//  CollectionTreeStorageProtocol.swift
//  Tree
//
//  Created by Henry on 2019/06/28.
//  Copyright © 2019 Eonil. All rights reserved.
//

/// A central storage that contains collection-tree.
///
/// `CollectionTree` can come in various forms.
/// This defines storages for central storage type collection-trees.
///
/// This is almost equal to `CollectionTreeProtocol` except
/// that this does not require `Collection.Element == Self`
/// which cannot be satisfied.
public protocol CollectionTreeStorageProtocol {
    /// Root collection.
    var collection: Collection { get }
    associatedtype Collection: Swift.Collection where
        Collection.Element: CollectionTreeProtocol
}
