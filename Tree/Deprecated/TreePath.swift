//
//  TreePath.swift
//  Tree
//
//  Created by Henry on 2019/06/21.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

/// Default implementation for `TreePathProtocol`.
public struct TreePath<Element>: TreePathProtocol where Element: Comparable {
    private var impl = ArraySlice<Element>()

    public init() {}
    public init<C>(_ c: C) where C: Collection, C.Element == Element {
        impl.append(contentsOf: c)
    }
    public init(arrayLiteral elements: Element...) {
        impl.append(contentsOf: elements)
    }
    public var startIndex: Int {
        return impl.startIndex
    }
    public var endIndex: Int {
        return impl.endIndex
    }
    public subscript(_ i: Int) -> Element {
        return impl[i]
    }
    public subscript(_ b: Range<Int>) -> TreePath {
        return TreePath(impl[b])
    }
    public mutating func append(_ e: Element) {
        impl.append(e)
    }
}
