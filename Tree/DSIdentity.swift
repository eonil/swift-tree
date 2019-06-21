//
//  DSIdentity.swift
//  Tree
//
//  Created by Henry on 2019/06/21.
//  Copyright © 2019 Eonil. All rights reserved.
//

struct DSIdentity: Hashable, Comparable {
    private let mk = Marker()
    init() {}
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(mk))
    }
    static func == (lhs: DSIdentity, rhs: DSIdentity) -> Bool {
        return lhs.mk === rhs.mk
    }
    static func < (lhs: DSIdentity, rhs: DSIdentity) -> Bool {
        return ObjectIdentifier(lhs.mk) < ObjectIdentifier(rhs.mk)
    }
}
private final class Marker {}
