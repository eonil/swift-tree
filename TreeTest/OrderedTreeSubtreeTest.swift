//
//  OrderedTreeSubtreeTest.swift
//  TreeTest
//
//  Created by Henry on 2019/06/24.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation
import XCTest
@testable import Tree

class OrderedTreeSubtreeTest: XCTestCase {
    func testBasics1() {
        var s = OrderedTree<Int>(111)
        let rootKey = s.subtree.key
        let rootValue = s.subtree.value
        XCTAssertEqual(s.count, 1)
        XCTAssertEqual(s[[]], 111)
        XCTAssertEqual(rootValue, 111)

        s[[]] = 222
        XCTAssertEqual(s.count, 1)
        XCTAssertEqual(s.impl.stateMap.count, 1)
        XCTAssertEqual(s.impl.linkageMap.count, 1)
        XCTAssertEqual(s.impl.stateMap[rootKey], 222)
        XCTAssertEqual(Array(s.impl.linkageMap[rootKey] ?? []), [])

        s.insert(333, at: [0])
        XCTAssertEqual(s.count, 2)
        XCTAssertEqual(s.impl.linkageMap.count, 2)
        XCTAssertNotNil(s.impl.linkageMap[rootKey])
        XCTAssertEqual(s.impl.linkageMap[rootKey]!.count, 1)
        let k1 = s.impl.linkageMap[rootKey]![0]
        XCTAssertEqual(Array(s.impl.linkageMap[rootKey] ?? []), [k1])
        XCTAssertEqual(s.impl.stateMap.count, 2)
        XCTAssertNotNil(s.impl.stateMap[k1])
        XCTAssertEqual(s.impl.stateMap[k1]!, 333)
        XCTAssertEqual(s.subtree.subkeys.count, 1)
        XCTAssertEqual(s.subtree.subkeys[0], k1)

        s.insert(444, at: [1])
        s.insert(555, at: [2])
        s.insert(666, at: [3])
        XCTAssertEqual(s.count, 5)
        XCTAssertEqual(s[[0]], 333)
        XCTAssertEqual(s[[1]], 444)
        XCTAssertEqual(s[[2]], 555)
        XCTAssertEqual(s[[3]], 666)

        s.insert(444111, at: [1,0])
        XCTAssertEqual(s.count, 6)
        XCTAssertEqual(s[[1,0]], 444111)
        XCTAssertEqual(s.subtree.subtree(at: 1).subtree(at: 0).value, 444111)

        var x = s.subtree
        x.insert(999, at: 0)
        x.insert(888, at: 0)
        XCTAssertEqual(x.tree.count, 8)
        XCTAssertEqual(Array(x), [888,999,333,444,555,666])
        XCTAssertEqual(x.tree[[]], 222)
        XCTAssertEqual(x.tree[[0]], 888)
        XCTAssertEqual(x.tree[[1]], 999)
        XCTAssertEqual(x.tree[[2]], 333)
        XCTAssertEqual(x.tree[[3]], 444)
        XCTAssertEqual(x.tree[[3,0]], 444111)

        x.remove(at: 1)
        XCTAssertEqual(x.tree.count, 7)
        XCTAssertEqual(Array(x), [888,333,444,555,666])
        XCTAssertEqual(x.tree[[]], 222)
        XCTAssertEqual(x.tree[[0]], 888)
        XCTAssertEqual(x.tree[[1]], 333)
        XCTAssertEqual(x.tree[[2]], 444)
        XCTAssertEqual(x.tree[[2,0]], 444111)
        XCTAssertEqual(x.tree[[3]], 555)
        XCTAssertEqual(x.tree[[4]], 666)

        x.remove(at: 2)
        XCTAssertEqual(x.tree.count, 5)
    }
}
