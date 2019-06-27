//
//  PersistentOrderedRootlessTreeMapTest.swift
//  TreeTest
//
//  Created by Henry on 2019/06/26.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation
import XCTest
@testable import Tree

class PersistentOrderedRootlessTreeMapTest: XCTestCase {
    func testBasica1() {
        let a = PersistentOrderedMapTree<Int,String>()
        var b = a.subtree
        b.insert((222,"bbb"), at: 0)
        b.insert((333,"ccc"), at: 1)
        b.insert((444,"ddd"), at: 2)
        XCTAssertEqual(b.startIndex, 0)
        XCTAssertEqual(b.endIndex, 3)
        let c = Array(b)
        XCTAssertEqual(c.map({ $0.0 }), [222,333,444])

        var d = b.subtree(at: 1)
        d.insert((333_111,"ccc_aaa"), at: 0)
        d.insert((333_222,"ccc_bbb"), at: 1)
        d.insert((333_333,"ccc_ccc"), at: 2)

        let e = d.tree
        XCTAssertEqual(e[[0]].key, 222)
        XCTAssertEqual(e[[0]].value, "bbb")
        XCTAssertEqual(e[[1]].key, 333)
        XCTAssertEqual(e[[1]].value, "ccc")
        XCTAssertEqual(e[[1,0]].key, 333_111)
        XCTAssertEqual(e[[1,0]].value, "ccc_aaa")
        XCTAssertEqual(e[[2]].key, 444)
        XCTAssertEqual(e[[2]].value, "ddd")
    }
}
