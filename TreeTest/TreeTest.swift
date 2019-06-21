//
//  TreeTest.swift
//  TreeTest
//
//  Created by Henry on 2019/06/21.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation
import XCTest
@testable import Tree

class TreeTest: XCTestCase {
    func testDFSIteration() {
        typealias X = Tree<Int>
        var x = X()
        x.insert(11, at: [])
        x.insert(22, at: [0])
        x.insert(33, at: [0,0])
        x.insert(44, at: [0,1])
        x.insert(55, at: [1])
        x.insert(66, at: [1,0])

        var i = x.paths.startIndex
        XCTAssertEqual(x.paths[i], [])
        XCTAssertEqual(x[x.paths[i]], 11)

        i = x.paths.index(after: i)
        XCTAssertEqual(x.paths[i], [0])
        XCTAssertEqual(x[x.paths[i]], 22)

        i = x.paths.index(after: i)
        XCTAssertEqual(x.paths[i], [0,0])
        XCTAssertEqual(x[x.paths[i]], 33)

        i = x.paths.index(after: i)
        XCTAssertEqual(x.paths[i], [0,1])
        XCTAssertEqual(x[x.paths[i]], 44)

        i = x.paths.index(after: i)
        XCTAssertEqual(x.paths[i], [1])
        XCTAssertEqual(x[x.paths[i]], 55)

        i = x.paths.index(after: i)
        XCTAssertEqual(x.paths[i], [1,0])
        XCTAssertEqual(x[x.paths[i]], 66)

        i = x.paths.index(after: i)
        XCTAssertEqual(i, x.paths.endIndex)
    }
//    func testPathSelection() {
//        let x = X(value: 11, subtrees: [
//            X(value: 22, subtrees: [
//                X(value: 33, subtrees: []),
//                X(value: 44, subtrees: []),
//                ]),
//            X(value: 55, subtrees: [
//                X(value: 66, subtrees: []),
//                ])
//            ])
//        XCTAssertEqual(x[[]].value, 11)
//        XCTAssertEqual(x[[0]].value, 22)
//        XCTAssertEqual(x[[0,0]].value, 33)
//        XCTAssertEqual(x[[0,1]].value, 44)
//        XCTAssertEqual(x[[1]].value, 55)
//        XCTAssertEqual(x[[1,0]].value, 66)
//    }
//    func test1() {
//        let x = X(value: 11, subtrees: [
//            X(value: 22, subtrees: [
//                X(value: 33, subtrees: []),
//                X(value: 44, subtrees: []),
//                ]),
//            X(value: 55, subtrees: [
//                X(value: 66, subtrees: []),
//                ])
//            ])
//
//        let a = x.map({ $0.value })
//        XCTAssertEqual(a, [11,22,33,44,55,66])
//    }
}

