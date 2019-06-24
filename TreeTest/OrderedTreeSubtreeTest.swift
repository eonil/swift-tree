//
//  OrderedTreeSubtreeTest.swift
//  TreeTest
//
//  Created by Henry on 2019/06/24.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation

import Foundation
import XCTest
@testable import Tree

class OrderedTreeSubtreeTest: XCTestCase {
    func testBasics1() {
        var s = OrderedTree<Int>.Subtree(111)
        let a = s[[]] as Int
        XCTAssertEqual(a, 111)
    }
}
