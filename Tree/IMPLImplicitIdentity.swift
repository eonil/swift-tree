//
//  IMPLImplicitIdentity.swift
//  Tree
//
//  Created by Henry on 2019/06/24.
//  Copyright © 2019 Eonil. All rights reserved.
//

struct IMPLImplicitIdentity: Hashable, Comparable {
    private let mk = Marker()
    init() {}
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(mk))
    }
    static func == (lhs: IMPLImplicitIdentity, rhs: IMPLImplicitIdentity) -> Bool {
        return lhs.mk === rhs.mk
    }
    static func < (lhs: IMPLImplicitIdentity, rhs: IMPLImplicitIdentity) -> Bool {
        return ObjectIdentifier(lhs.mk) < ObjectIdentifier(rhs.mk)
    }
}
private final class Marker {}
