//
//  IMPLOrderedTreeMapBFS.swift
//  Tree
//
//  Created by Henry on 2019/06/24.
//  Copyright © 2019 Eonil. All rights reserved.
//

import BTree

/// This iterator is finished is `target == nil`.
struct IMPLOrderedTreeMapBFS<K,V> where K:Comparable {
    private(set) var source:S
    private(set) var queue:List<K>
    typealias S = IMPLOrderedTreeMap<K,V>
    init(_ s:S) {
        source = s
        queue = []
    }
    init(_ s:S, from k:K) {
        source = s
        queue = s.linkageMap[k]!
    }
    var target:K? {
        return queue.first
    }
    var canStep:Bool {
        return !queue.isEmpty
    }
    mutating func step() {
        precondition(canStep, "You cannot step finished iterator.")
        let k = queue.removeFirst()
        queue.append(contentsOf: source.linkageMap[k]!)
    }
}
