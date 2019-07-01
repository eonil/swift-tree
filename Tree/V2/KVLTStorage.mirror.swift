//
//  KVLTStorage.mirror.swift
//  Tree
//
//  Created by Henry on 2019/07/01.
//  Copyright © 2019 Eonil. All rights reserved.
//

public extension KVLTStorage {
    var customMirror: Mirror {
        let c = impl.subkeys(for: nil).map({ BX(impl: impl, k: $0) })
        return Mirror(self, children: [
            "collection": c])
    }
}

private struct BX<K,V>: CustomReflectable where K:Comparable {
    var impl:IMPLPersistentOrderedMapTree<K,V>
    var k:K
    var customMirror: Mirror {
        let v = impl.value(for: k)
        let c = impl.subkeys(for: k).map({ BX(impl: impl, k: $0) })
        return Mirror(k, children: [
            "key": k,
            "value": v,
            "collection": c,
            ])
    }
}
