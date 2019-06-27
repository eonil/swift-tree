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
}
