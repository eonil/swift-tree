////
////  KVLTStorage.lazy.swift
////  Tree
////
////  Created by Henry on 2019/06/27.
////  Copyright © 2019 Eonil. All rights reserved.
////
//
/////// Implement on top of concrete type `KVLTStorage`
/////// as compiler keep failing.
////
////public extension KVLTStorage {
////    struct Lazy {
////        private(set) var base: Base
////    }
////}
////public extension KVLTStorage.Lazy {
////    typealias Base = KVLTStorage
//////    func mapValues<Derived>(_ fx: @escaping (Base.Value) -> Derived) -> LazyValueMappedKVLTStorage<Base,Derived> {
//////        return LazyValueMappedKVLTStorage<Base,Derived>(base: base, fx: fx)
//////    }
////}
////
////public struct LazyValueMappedKVLTStorage<Base,Derived>: KVLTStorageProtocol where
////Base: KVLTStorageProtocol,
////Base.Key == Base.List.Element.Key,
////Base.Value == Base.List.Element.Value {
////    private(set) var base: Base
////    private(set) var fx: (Base.Value) -> Derived
////}
////public extension LazyValueMappedKVLTStorage {
////    typealias Key = Base.Key
////    typealias Value = Derived
////    typealias Collection = List
////    typealias List = LazyValueMappedKVLTList<Base.List,Derived>
////    typealias Tree = LazyValueMappedKVLT<Base.Tree,Derived>
////    typealias MapValue = (Base.Value) -> Derived
////    subscript(k: Key) -> Derived { return fx(base[k]) }
////    var collection: List { return List(base: base.collection, fx: fx) }
////    func collection(of pk: Base.Key?) -> List {
////        return List(base: base.collection(of: pk), fx: fx)
////    }
////    func tree(for k: Base.Key) -> Tree {
////        return Tree(base: base.tree(for: k), fx: fx)
////    }
////}
//
//public extension KVLTStorage.List {
//    /// - TODO:
//    ///     I couldn't find a way to make Swift compiler to work with
//    ///     lazy implementation with `KVLTStorage` type.
//    ///     This is an workaround for it.
//    func lazyValueMapped<Derived>(_ fx: @escaping (Value) -> Derived) -> LazyValueMappedKVLTList<KVLTStorage.List,Derived> {
//        return LazyValueMappedKVLTList<KVLTStorage.List,Derived>(base: self, fx: fx)
//    }
//}
//
//public struct LazyValueMappedKVLTList<Base,Derived>: KVLTListProtocol where Base: KVLTListProtocol {
//    private(set) var base: Base
//    private(set) var fx: (Base.Element.Value) -> Derived
//}
//public extension LazyValueMappedKVLTList {
//    typealias Index = Base.Index
//    typealias Element = Tree
//    typealias Tree = LazyValueMappedKVLT<Base.Element,Derived>
//    var startIndex: Index { return base.startIndex }
//    var endIndex: Index { return base.endIndex }
//    subscript(_ i: Index) -> Tree { return Tree(base: base[i], fx: fx) }
//}
//
//
//
//
//public extension KVLTStorage.Tree {
//    /// - TODO:
//    ///     I couldn't find a way to make Swift compiler to work with
//    ///     lazy implementation with `KVLTStorage` type.
//    ///     This is an workaround for it.
//    func lazyValueMapped<Derived>(_ fx: @escaping (Value) -> Derived) -> LazyValueMappedKVLT<KVLTStorage.Tree,Derived> {
//        return LazyValueMappedKVLT<KVLTStorage.Tree,Derived>(base: self, fx: fx)
//    }
//}
//
//public struct LazyValueMappedKVLT<Base,Derived>: KVLTProtocol where Base: KVLTProtocol {
//    private(set) var base: Base
//    private(set) var fx: (Base.Value) -> Derived
//}
//public extension LazyValueMappedKVLT {
//    typealias Key = Base.Key
//    typealias Value = Derived
//    typealias Collection = List
//    typealias List = LazyValueMappedKVLTList<Base.Collection,Derived>
//    var key: Key { return base.key }
//    var value: Value { return fx(base.value) }
//    var collection: List { return List(base: base.collection, fx: fx) }
//}
