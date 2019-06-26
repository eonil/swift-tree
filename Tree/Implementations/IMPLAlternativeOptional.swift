//
//  IMPLAlternativeOptional.swift
//  Tree
//
//  Created by Henry on 2019/06/26.
//  Copyright © 2019 Eonil. All rights reserved.
//

/// Drop-in replacement for `Optional`.
/// Because `K?` produces compiler segfaults in `BTree.Map<K?,V>`...
///
struct IMPLAlternativeOptional<K>: Comparable where K:Comparable {
    var k:K?
    init(_ x:K?) {
        k = x
    }
    public static func == (lhs: IMPLAlternativeOptional, rhs: IMPLAlternativeOptional) -> Bool {
        switch (lhs.k,rhs.k) {
        case (nil,nil): return true
        case (nil,_):   return false
        case (_,nil):   return false
        case (_,_):     return lhs.k! == rhs.k!
        }
    }
    public static func < (lhs: IMPLAlternativeOptional, rhs: IMPLAlternativeOptional) -> Bool {
        switch (lhs.k,rhs.k) {
        case (nil,nil): return false // Because they're equal.
        case (nil,_):   return true  // Because nothing is less than something.
        case (_,nil):   return false
        case (_,_):     return lhs.k! < rhs.k!
        }
    }
}

