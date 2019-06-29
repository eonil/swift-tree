//
//  ListTreeStorageTest.swift
//  TreeTest
//
//  Created by Henry on 2019/06/29.
//  Copyright © 2019 Eonil. All rights reserved.
//

import XCTest
@testable import Tree

class ListTreeStorageTest: XCTestCase {
    func testInsert() {
        var s = ListTreeStorage<Int>()
        s.insert(111, at: [0])
        XCTAssertEqual(s.collection.count, 1)
        XCTAssertEqual(s.collection[0].value, 111)
    }
    func testRemove() {
        var s = ListTreeStorage<Int>()
        s.insert(111, at: [0])
        s.remove(at: [0])
        XCTAssertEqual(s.collection.count, 0)
    }
    func testRemoveTwoDepth() {
        var s = ListTreeStorage<Int>()
        s.insert(111, at: [0])
        s.insert(222, at: [0,0])
        s.remove(at: [0,0])
        XCTAssertEqual(s.collection.count, 1)
        XCTAssertEqual(s.collection[0].collection.count, 0)
        XCTAssertEqual(s[[0]].value, 111)
    }
}
