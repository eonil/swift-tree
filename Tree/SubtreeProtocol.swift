//
//  SubtreeProtocol.swift
//  Tree
//
//  Created by Henry on 2019/06/22.
//  Copyright © 2019 Eonil. All rights reserved.
//

/// An interface to query tree structure easily and quickly.
///
public protocol SubtreeProtocol {
    var index: Index { get }
    associatedtype Index

    var path: Path { get }
    associatedtype Path

    var element: Element { get }
    associatedtype Element

    var subtrees: SubtreeCollection { get }
    associatedtype SubtreeCollection: RandomAccessCollection where
        SubtreeCollection.Element == Self
}
