//
//  IMPLPersistentOrderedTreeMapTest.swift
//  TreeTest
//
//  Created by Henry on 2019/06/24.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation
import XCTest
@testable import Tree

class IMPLPersistentOrderedTreeMapTest: XCTestCase {
    func testBasica1() {
        var a = IMPLPersistentOrderedTreeMap<Int,String>(root: (111,"aaa"))
        a.setState("aaa-aaa", for: 111)
        XCTAssertEqual(a.stateMap.count, 1)
        XCTAssertNotNil(a.stateMap[111])
        XCTAssertEqual(a.stateMap[111], "aaa-aaa")
        XCTAssertEqual(a.linkageMap.count, 1)
        XCTAssertNotNil(a.linkageMap[111])
        XCTAssertEqual(Array(a.linkageMap[111]!), [])
        a.replaceSubrange(0..<0, in: 111, with: [(222,"bbb")])
        XCTAssertEqual(a.stateMap.count, 2)
        XCTAssertNotNil(a.stateMap[222])
        XCTAssertEqual(a.stateMap[222]!, "bbb")
        XCTAssertEqual(a.linkageMap.count, 2)
        XCTAssertNotNil(a.linkageMap[222])
        XCTAssertEqual(Array(a.linkageMap[222]!), [])
        XCTAssertEqual(Array(a.linkageMap[111]!), [222])
    }
}
