//
//  ListTreeStorage.mirror.swift
//  Tree
//
//  Created by Henry on 2019/07/01.
//  Copyright © 2019 Eonil. All rights reserved.
//

public extension ListTreeStorage {
    var customMirror: Mirror {
        return Mirror(self, children: [
            "collection": Array(collection)])
    }
}

public extension ListTree {
    var customMirror: Mirror {
        return Mirror(self, children: [
            "value": value,
            "collection": Array(collection)])
    }
}
