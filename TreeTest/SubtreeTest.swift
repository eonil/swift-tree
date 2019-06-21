////
////  SubtreeTest.swift
////  TreeTest
////
////  Created by Henry on 2019/06/21.
////  Copyright © 2019 Eonil. All rights reserved.
////
//
//import Foundation
//import XCTest
//@testable import Tree
//
//class SubtreeTest: XCTestCase {
//    func testDFSIteration() {
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
//        var i = x.startIndex
//        XCTAssertEqual(i.position, [])
//        XCTAssertEqual(x[i].value, 11)
//
//        i = x.index(after: i)
//        XCTAssertEqual(i.position, [0])
//        XCTAssertEqual(x[i].value, 22)
//
//        i = x.index(after: i)
//        XCTAssertEqual(i.position, [0,0])
//        XCTAssertEqual(x[i].value, 33)
//
//        i = x.index(after: i)
//        XCTAssertEqual(i.position, [0,1])
//        XCTAssertEqual(x[i].value, 44)
//
//        i = x.index(after: i)
//        XCTAssertEqual(i.position, [1])
//        XCTAssertEqual(x[i].value, 55)
//
//        i = x.index(after: i)
//        XCTAssertEqual(i.position, [1,0])
//        XCTAssertEqual(x[i].value, 66)
//
//        i = x.index(after: i)
//        XCTAssertEqual(i.position, nil)
//        XCTAssertEqual(i, x.endIndex)
//    }
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
//}
//
//private struct X: TreeProtocol {
//    typealias Index = TreeIndex<X>
//    typealias Path = TreePath<Int>
//    var value = 0
//    var subtrees = [X]()
//}
//
