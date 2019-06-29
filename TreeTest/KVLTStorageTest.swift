//
//  KVLTStorageTest.swift
//  TreeTest
//
//  Created by Henry on 2019/06/28.
//  Copyright © 2019 Eonil. All rights reserved.
//

import XCTest
@testable import Tree

class KVLTStorageTest: XCTestCase {
    func testCount() {
        var s = KVLTStorage<Int,String>()
        XCTAssertEqual(s.count, 0)
        XCTAssertEqual(s.isEmpty, true)

        s.append((111,"aaa"), in: nil)
        XCTAssertEqual(s.count, 1)
        XCTAssertEqual(s.isEmpty, false)

        s.append((222,"bbb"), in: nil)
        XCTAssertEqual(s.count, 2)
        XCTAssertEqual(s.isEmpty, false)

        s.append((333,"ccc"), in: nil)
        XCTAssertEqual(s.count, 3)
        XCTAssertEqual(s.isEmpty, false)
    }
    func testInsertChildWithOneDepth() {
        var s = KVLTStorage<Int,String>()

        s.insert((111,"aaa"), at: 0, in: nil)
        XCTAssertEqual(s.collection.count, 1)
        XCTAssertEqual(s.collection[0].key, 111)
        XCTAssertEqual(s.collection[0].value, "aaa")
        XCTAssertEqual(s.collection[0].collection.count, 0)

        s.insert((222,"bbb"), at: 0, in: 111)
        XCTAssertEqual(s.collection[0].collection.count, 1)
        XCTAssertEqual(s.collection[0].collection[0].key, 222)
        XCTAssertEqual(s.collection[0].collection[0].value, "bbb")

        s.insert((333,"ccc"), at: 1, in: 111)
        XCTAssertEqual(s.collection[0].collection.count, 2)
        XCTAssertEqual(s.collection[0].collection[1].key, 333)
        XCTAssertEqual(s.collection[0].collection[1].value, "ccc")
    }
    func testInsertChildWithTwoDepths() {
        var s = KVLTStorage<Int,String>()

        s.insert((111,"aaa"), at: 0, in: nil)
        XCTAssertEqual(s.collection.count, 1)
        XCTAssertEqual(s.collection[0].key, 111)
        XCTAssertEqual(s.collection[0].value, "aaa")
        XCTAssertEqual(s.collection[0].collection.count, 0)

        s.insert((222,"bbb"), at: 0, in: 111)
        XCTAssertEqual(s.collection[0].collection.count, 1)
        XCTAssertEqual(s.collection[0].collection[0].key, 222)
        XCTAssertEqual(s.collection[0].collection[0].value, "bbb")

        s.insert((333,"ccc"), at: 0, in: 222)
        XCTAssertEqual(s.collection[0].collection[0].collection.count, 1)
        XCTAssertEqual(s.collection[0].collection[0].collection[0].key, 333)
        XCTAssertEqual(s.collection[0].collection[0].collection[0].value, "ccc")
    }
}
