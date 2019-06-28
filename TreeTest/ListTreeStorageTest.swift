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
    func test1() {
        var s = ListTreeStorage<Int>()
        s.insert(111, at: [0])
        XCTAssertEqual(s.collection.count, 1)
        XCTAssertEqual(s.collection[0].value, 111)
    }
}
