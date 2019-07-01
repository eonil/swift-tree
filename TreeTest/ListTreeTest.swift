//
//  ListTreeTest.swift
//  TreeTest
//
//  Created by Henry on 2019/06/29.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation
import XCTest
@testable import Tree

class ListTreeTest: XCTestCase {
    func testInsert() {
        var x = ListTree(value: 111)
        let ts = [222,333,444].map({ ListTree(value: $0 )})
        x.insert(contentsOf: ts, at: 0, in: [])
        let vs = x.collection.map({ $0.value })
        XCTAssertEqual(vs, [222,333,444])

        x.insert(999, at: [1,0])
        XCTAssertEqual(x.collection[1].collection[0].value, 999)
    }
    func testRemove() {
        var x = ListTree(value: 111)
        do {
            x.insert(222, at: [0])
            x.insert(333, at: [0,0])
            x.insert(444, at: [0,1])
            x.insert(555, at: [0,2])
            x.insert(66, at: [1])
            x.insert(77, at: [2])
            let vs = x.collection[0].collection.map({ $0.value })
            XCTAssertEqual(vs, [333,444,555])
        }
        do {
            x.removeSubrange(1..<2, in: [])
            let vs = x.collection.map({ $0.value })
            XCTAssertEqual(vs, [222,77])
        }
        do {
            x.removeSubrange(1..<2, in: [0])
            let vs1 = x.collection[0].collection.map({ $0.value })
            XCTAssertEqual(vs1, [333,555])
        }
    }
}
