//
//  IMPLPersistentOrderedRootlessTreeMapTest.swift
//  TreeTest
//
//  Created by Henry on 2019/06/26.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation
import XCTest
@testable import Tree

class IMPLPersistentOrderedMapTreeTest: XCTestCase {
    func testBasica1() {
        var a = IMPLPersistentOrderedMapTree<Int,String>()
        a.insert((111,"aaa"), at: 0, in: nil)
        XCTAssertEqual(Array(a.subkeys(for: nil)), [111])
        XCTAssertEqual(Array(a.subkeys(for: 111)), [])

        a.insert((123,"___"), at: 0, in: 111)
        XCTAssertEqual(Array(a.subkeys(for: 111)), [123])
        a.removeSubtree(at: 0, in: 111)
        XCTAssertEqual(Array(a.subkeys(for: 111)), [])

        a.insert((222,"bbb"), at: 0, in: nil)
        a.insert((333,"ccc"), at: 0, in: nil)
        XCTAssertEqual(a.count, 3)
        XCTAssertEqual(Array(a.subkeys(for: nil)), [333,222,111])
        a.removeSubtrees(1..<2, in: nil)
        XCTAssertEqual(a.count, 2)
        XCTAssertEqual(Array(a.subkeys(for: nil)), [333,111])
        a.insert(
            contentsOf: [(555,"eee"),(666,"fff"),(777,"ggg")],
            at: 1,
            in: nil)
        XCTAssertEqual(a.count, 5)
        XCTAssertEqual(Array(a.subkeys(for: nil)), [333,555,666,777,111])
        a.insert(contentsOf: [(88,"hh"),(99,"ii")], at: 0, in: 111)
        XCTAssertEqual(a.count, 7)
        XCTAssertEqual(Array(a.subkeys(for: 111)), [88,99])
        XCTAssertEqual(a.value(for: 88), "hh")
        XCTAssertEqual(a.value(for: 99), "ii")

        a.removeSubtree(at: 4, in: nil)
        XCTAssertEqual(a.count, 4)
        XCTAssertEqual(Array(a.subkeys(for: nil)), [333,555,666,777])
    }
}
