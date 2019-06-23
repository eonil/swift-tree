//
//  ImplCursor2.swift
//  Tree
//
//  Created by Henry on 2019/06/23.
//  Copyright © 2019 Eonil. All rights reserved.
//

import Foundation
import SBTL
/// Just a position indicator.
/// This does not care actual validity of indicated position.
///
/// Not tested yet...
struct ImplCursor2<Element> {
    typealias Source = ImplPersistentMapBasedTree<Element>
    typealias Identity = ImplIdentity
    typealias Siblings = BTL<Identity>
    var source: Source
    var targetPath = IndexPath()
    var siblingStack = [Siblings]() // at index 0, siblings of root node.
    var indexInSiblings = 0

    init(source s: Source) {
        source = s
        siblingStack = s.isEmpty ? [[]] : [[s.rootID!]]
    }
    var parentSiblings: Siblings {
        return siblingStack[targetPath.count-1]
    }
    var currentSiblings: Siblings {
        return siblingStack[targetPath.count]
    }
    var parentIdentity: Identity {
        return parentSiblings[targetPath.last!]
    }
    var currentIdentity: Identity {
        return currentSiblings[indexInSiblings]
    }

    mutating func moveToParent() {
        targetPath.removeLast()
        siblingStack.removeLast()
    }
    mutating func moveToChild(at i: Int) {
        let id = currentIdentity
        targetPath.append(i)
        siblingStack.append(source.children(of: id))
    }
    mutating func moveToPreviousSibling() {
        let i = indexInSiblings
        moveToParent()
        moveToChild(at: i-1)
    }
    mutating func moveToNextSibling() {
        let i = indexInSiblings
        moveToParent()
        moveToChild(at: i+1)
    }
    mutating func insertChildAndMoveToIt(_ e: Element, at i: Int) {
        let id = currentIdentity
        let cids = source.insert(e, at: i, asChildOf: id)
        targetPath.append(i)
        siblingStack.append(cids)
    }
    mutating func replaceCurrent(with e: Element) {
        source.setState(of: currentIdentity, as: e)
    }
    mutating func replaceChildAndMoveToIt(at i: Int, with e: Element) {
        let id = currentIdentity
        let cids = source.children(of: id)
        let cid = cids[i]
        source.setState(of: cid, as: e)
        targetPath.append(i)
        siblingStack.append(cids)
    }
    mutating func removeCurrentAndMoveToParent() {
        let id = currentIdentity
        source.removeRecursively(id)
        targetPath.removeLast()
        siblingStack.removeLast()
    }
    mutating func removeChild(at i: Int) {
        let cids = source.children(of: currentIdentity)
        let cid = cids[i]
        source.removeRecursively(cid)
    }
}

//extension IndexPath {
//    mutating func parent() {
//        precondition(!isEmpty, "Bad movement. This is root path.")
//        removeLast()
//    }
//    mutating func moveToChild(at i: Int) {
//        append(i)
//    }
//    mutating func moveToPreviousSibling() {
//        precondition(last != nil, "Bad movement. This is root path.")
//        let i = last!
//        parent()
//        moveToChild(at: i-1)
//    }
//    mutating func moveToNextSibling() {
//        precondition(last != nil, "Bad movement. This is root path.")
//        let i = last!
//        parent()
//        moveToChild(at: i+1)
//    }
//}
