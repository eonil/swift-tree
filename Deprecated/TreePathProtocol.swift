//
//  TreePathProtocol.swift
//  Tree
//
//  Created by Henry on 2019/06/21.
//  Copyright © 2019 Eonil. All rights reserved.
//

public protocol TreePathProtocol:
Comparable,
RandomAccessCollection,
ExpressibleByArrayLiteral where
Element: Comparable,
SubSequence == Self {
    mutating func append(_: Element)
    func appending(_: Element) -> Self
}
public extension TreePathProtocol {
    func appending(_ e: Element) -> Self {
        var x = self
        x.append(e)
        return x
    }
}
public extension TreePathProtocol {
    static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.count == rhs.count else { return false }
        for (a,b) in zip(lhs,rhs) {
            guard a == b else { return false }
        }
        return true
    }
    static func < (lhs: Self, rhs: Self) -> Bool {
        var a = lhs.makeIterator()
        var b = rhs.makeIterator()
        while true {
            let a1 = a.next()
            let b1 = b.next()
            switch (a1,b1) {
            case (nil,nil):         return true
            case (_,nil):           return true
            case (nil,_):           return false
            case (let a2, let b2):
                if a2! < b2! { return true }
                if a2! > b2! { return false }
            }
        }
    }
}
