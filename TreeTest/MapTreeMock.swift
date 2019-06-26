//
//  TreeMock.swift
//  TreeTest
//
//  Created by Henry on 2019/06/26.
//  Copyright © 2019 Eonil. All rights reserved.
//

import XCTest
@testable import Tree

typealias MapTree<K,V> = PersistentOrderedRootlessMapTree<K,V> where K: Comparable

struct MapTreeMock {
    typealias K = Int
    typealias V = String
    typealias Snapshot = MapTree<K,V>
    typealias Element = Snapshot.Element

    private(set) var prng = ReproduciblePRNG(1_000_000)
    private(set) var newKeyPRNG = ReproduciblePRNG(1_000_000)
    private(set) var snapshot = Snapshot()
}
extension MapTreeMock {
    /// Returns a new key that is not contained in latest source snapshot.
    mutating func makeNewRandomKey() -> K {
        var k = newKeyPRNG.nextWithRotation()
        while snapshot.keys.contains(k) {
            k = newKeyPRNG.nextWithRotation()
        }
        return k
    }
    mutating func randomKeyInLatestSnapshot() -> K {
        let c = snapshot.count
        let n = prng.nextWithRotation(in: 0..<c)
        let i = snapshot.index(snapshot.startIndex, offsetBy: n)
        let e = snapshot[i]
        return e.0
    }
    /// Selects `nil` in 1% or snapshot is empty.
    mutating func selectRandomParentKey() -> K? {
        if snapshot.count == 0 { return nil }
        if prng.nextWithRotation(in: 0..<100) == 0 { return nil }
        return randomKeyInLatestSnapshot()
    }
    mutating func selectRandomInsertionIndexInKey(in k:K?) -> Int {
        let s = snapshot.subtree(for: k)
        let i = prng.nextWithRotation(in: 0..<s.count+1)
        return i
    }
    mutating func selectRandomUpdateOrRemoveIndexInKey(in k:K?) -> Int? {
        let s = snapshot.subtree(for: k)
        guard s.count > 0 else { return nil }
        let i = prng.nextWithRotation(in: 0..<s.count)
        return i
    }

    mutating func stepRandom(_ n: Int = 1) {
        for _ in 0..<n {
            switch prng.nextWithRotation(in: 0..<3) {
            case 0:     insertRandom()
            case 1:     updateRandomValue()
            case 2:     removeRandomRecursively()
            default:    fatalError()
            }
        }
    }
    mutating func insertRandom() {
        let pk = selectRandomParentKey()
        let i = selectRandomInsertionIndexInKey(in: pk)
        let k = makeNewRandomKey()
        let v = "\(k)"
        snapshot.insert(contentsOf: [(k,v)], at: i, in: pk)
    }
    mutating func updateRandomValue() {
        guard snapshot.count > 0 else { return }
        let pk = selectRandomParentKey()
        guard let i = selectRandomUpdateOrRemoveIndexInKey(in: pk) else { return }
        let (k,v) = snapshot.subtree(for: pk)[i]
        let v1 = "\(v)."
        snapshot[k] = v1
    }
    mutating func removeRecursively(at i: Int, in pk: K?) {
        let s = snapshot.subtree(for: pk)
        let x = s.subtree(at: i)
        let k = s[i].key
        for i in 0..<x.count {
            removeRecursively(at: i, in: k)
        }
    }
    mutating func removeRandomRecursively() {
        guard snapshot.count > 0 else { return }
        let pk = selectRandomParentKey()
        guard let i = selectRandomUpdateOrRemoveIndexInKey(in: pk) else { return }
        removeRecursively(at: i, in: pk)
    }
}

extension MapTreeMock {
    func validate() {
        var t = ValidationStat()
        for i in 0..<snapshot.subtree.count {
            let t1 = validate(at: i, in: nil)
            t.count += t1.count
        }
        XCTAssertEqual(t.count, snapshot.count)
    }
    func validate(at i: Int, in pk: K?) -> ValidationStat {
        var t = ValidationStat()
        t.count += 1
        let s = snapshot.subtree(for: pk)
        let (k,v) = s[i]
        XCTAssertEqual(snapshot[k], v)
        let s1 = s.subtree(at: i)
        for i1 in 0..<s1.count {
            let t1 = validate(at: i1, in: k)
            t.count += t1.count
        }
        return t
    }
    struct ValidationStat {
        var count = 0
    }
}
