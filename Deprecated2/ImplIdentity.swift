//
//  ImplIdentity.swift
//  Tree
//
//  Created by Henry on 2019/06/21.
//  Copyright © 2019 Eonil. All rights reserved.
//

@available(*,deprecated: 0)
struct ImplIdentity: Hashable, Comparable {
    private let mk = Marker()
    init() {}
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(mk))
    }
    static func == (lhs: ImplIdentity, rhs: ImplIdentity) -> Bool {
        return lhs.mk === rhs.mk
    }
    static func < (lhs: ImplIdentity, rhs: ImplIdentity) -> Bool {
        return ObjectIdentifier(lhs.mk) < ObjectIdentifier(rhs.mk)
    }
}
private final class Marker {}
