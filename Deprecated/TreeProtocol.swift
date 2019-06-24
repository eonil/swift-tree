//
//  TreeProtocol.swift
//  Tree
//
//  Created by Henry on 2019/06/21.
//  Copyright © 2019 Eonil. All rights reserved.
//

/// A nested collection.
///
/// You can build your own tree type easily by conforming `TreeProtocol`.
/// This library provides default implementations if you use these types for
/// your tree implementation.
///
/// - `Index == TreeIndex<Self>`
/// - `Path == IndexPath`
///
/// Therefore, minimal tree implementation would look like this.
///
///     private struct X: TreeProtocol {
///         typealias Index = TreeIndex<X>
///         typealias Path = TreePath<Int>
///         var subtrees = [X]()
///     }
///
public protocol TreeProtocol: Collection where
Element == Self {
    associatedtype Path: TreePathProtocol
    associatedtype SubtreeCollection: Collection where
        SubtreeCollection.Index == Path.Element,
        SubtreeCollection.Element == Self
    func contains(at: Path) -> Bool
    var subtrees: SubtreeCollection { get }
    func index(at: Path) -> TreeIndex<Self>
    subscript(_: TreeIndex<Self>) -> Self { get }
}

public protocol RandomAccessTreeProtocol: TreeProtocol where
SubtreeCollection: RandomAccessCollection {
}

/// A tree that allows updating elements without modifying existing topology of the tree.
///
///
///
public protocol MutableTreeProtocol: TreeProtocol where
SubtreeCollection: MutableCollection & RangeReplaceableCollection {
    var subtrees: SubtreeCollection { get set }
    subscript(_: Index) -> Self { get set }
}

public protocol RangeReplaceableTreeProtocol: TreeProtocol where
SubSequence: RangeReplaceableTreeProtocol {
    init()
    mutating func replaceSubrange<C>(_ subrange: Range<Index>, with: C) where
            C: Collection, C.Element == Element
}

public extension TreeProtocol {
    /// Checks whether a subtree exists or not at designated path.
    /// - Complexity: `O(log(n))`
    func contains(at p: Path) -> Bool {
        switch p.count {
        case 0:
            return true
        default:
            let i = p.first!
            let q = p.dropFirst()
            return subtrees[i].contains(at: q)
        }
    }
    /// Gets a subtree at path.
    /// - Complexity: `O(log(n))`
    subscript(_ p: Path) -> Self {
        switch p.count {
        case 0:
            return self
        default:
            let i = p.first!
            let p = p.dropFirst()
            return subtrees[i][p]
        }
    }
}

public extension TreeProtocol where Self: RangeReplaceableTreeProtocol {
    mutating func replaceSubrange<C>(_ subrange: Range<Index>, with: C) where
        C: Collection, C.Element == Element {
    }
}
