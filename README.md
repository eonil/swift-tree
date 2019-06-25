Tree
====
Eonil, 2019.

Some generalized key-value tree implementation.

In many cases, it's hard to archive certain level of performance with plain tree structure,
and you need unique identifiers for trees. In that case, 
you usually need key-value map-like tree structure.
Here `OrderedTreeMap` provides such key-value tree-map structure.



Getting Started
-------------------
Just initialize new `EphemeralOrderedMapTree` instance with root key-value pair,
and get `EphemeralOrderedMapTree.Subtree` instance from `subtree` property.

    let a = EphemeralOrderedMapTree<Int,String>((111,"aaa"))
    var b = a.subtree
    
You can insert key-value pairs like an `Array` instance. 

    b.insert((222,"bbb"), at: 0)
    b.insert((333,"ccc"), at: 1)
    b.insert((444,"ddd"), at: 2)
    
You can dive into deeper subtrees and modify it.    

    var d = b.subtree(at: 1)
    d.insert((333_111,"ccc_aaa"), at: 0)
    d.insert((333_222,"ccc_bbb"), at: 1)
    d.insert((333_333,"ccc_ccc"), at: 2)
    
Finally, you can retrieve whole tree back from subtree.
    
    let e = d.tree
    XCTAssertEqual(e[[0]].key, 222)
    XCTAssertEqual(e[[0]].value, "bbb")
    XCTAssertEqual(e[[1]].key, 333)
    XCTAssertEqual(e[[1]].value, "ccc")
    XCTAssertEqual(e[[1,0]].key, 333_111)
    XCTAssertEqual(e[[1,0]].value, "ccc_aaa")
    XCTAssertEqual(e[[2]].key, 444)
    XCTAssertEqual(e[[2]].value, "ddd")
    
Basically, you use `EphemeralOrderedMapTree` type to control overall tree level,
and use `EphemeralOrderedMapTree.Subtree` type to control single node and its direct children.

Conceptually, all `EphemeralOrderedMapTree` is a singly-rooted tree, and the instance itself
is regarded as root subtree. Therefore, there's always a root element, and you cannot
remove root element from `EphemeralOrderedMapTree` 
although you can change value of root elment.



Variants
---------
These variants are available.
- Persistent Ordered Map Tree.
- Persistent Unordered Map Tree.



Manitenance
------------------
- You are supposed to use `OrderedTreeMap` and `OrderedTree` types.
- `IMPL*` types internal implementation details to provide less complex
  shared internal storage types and utilities.



License
----------
This code is licensed under "MIT License". 
Copyright Eonil, Hoon H.. 2019. All rights reserved.


