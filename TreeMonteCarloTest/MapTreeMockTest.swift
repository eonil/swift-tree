//
//  MapTreeMockTest.swift
//  TreeTest
//
//  Created by Henry on 2019/06/26.
//  Copyright © 2019 Eonil. All rights reserved.
//

import XCTest
import TestUtil
@testable import Tree

class MapTreeTest: XCTestCase {
    func test1() {
        var m = MapTreeMock()
        for i in 0..<1_000_000 {
            m.stepRandom()
            m.validate()
            if i % 1_000 == 0 {
                print("#\(i), count: \(m.snapshot.count)")
            }
        }
    }
}
