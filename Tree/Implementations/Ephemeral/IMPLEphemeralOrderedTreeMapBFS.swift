//
//  IMPLEphemeralOrderedTreeMapBFS.swift
//  Tree
//
//  Created by Henry on 2019/06/24.
//  Copyright © 2019 Eonil. All rights reserved.
//

import BTree

/// This iterator is finished is `target == nil`.
struct IMPLEphemeralOrderedTreeMapBFS<K,V> where K:Hashable {
    private(set) var source:S
    private(set) var queue:Array<K>
    typealias S = IMPLEphemeralOrderedTreeMap<K,V>
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
