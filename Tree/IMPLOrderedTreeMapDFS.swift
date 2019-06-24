//
//  IMPLOrderedTreeMapDFS.swift
//  Tree
//
//  Created by Henry on 2019/06/24.
//  Copyright © 2019 Eonil. All rights reserved.
//

import BTree

/// This iterator is finished is `target == nil`.
struct IMPLOrderedTreeMapDFS<K,V> where K:Comparable {
    private(set) var source:S
    private(set) var reversedStack:List<K>
    typealias S = IMPLOrderedTreeMap<K,V>
    init(_ s:S) {
        source = s
        reversedStack = []
    }
    init(_ s:S, from k:K) {
        source = s
        reversedStack = s.linkageMap[k]!
    }
    var target:K? {
        return reversedStack.last
    }
    var canStep:Bool {
        return !reversedStack.isEmpty
    }
    mutating func step() {
        precondition(canStep, "You cannot step finished iterator.")
        let k = reversedStack.removeLast()
        reversedStack.append(contentsOf: source.linkageMap[k]!.lazy.reversed())
    }
}
