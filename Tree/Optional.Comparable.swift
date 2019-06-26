//
//  Optional.Comparable.swift
//  Tree
//
//  Created by Henry on 2019/06/26.
//  Copyright © 2019 Eonil. All rights reserved.
//

extension Optional: Comparable where Wrapped: Comparable {
    public static func < (lhs: Optional, rhs: Optional) -> Bool {
        switch (lhs,rhs) {
        case (nil,nil): return false // because they're equal.
        case (nil,_):   return false
        case (_,nil):   return false
        case (_,_):     return lhs! < rhs!
        }
    }
}
