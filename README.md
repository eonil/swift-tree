Tree
====
Eonil, 2019.




Manitenance
------------------
- Users are supposed to use `Tree` type and `TreeCollection` protocol.
- `IMPL*` types are defined to provide internal Data Storages structures.
- `IMPLRefMapTree` is an optimized tree structure with better data locality.




Specialization
----------------
`OrderedTreeSet` can be implemented easily on top of `OrderedTreeMap`
by storing `()` for values.

Plain `Tree` also can be implemented easily on top of `OrderedTreeMap`
by providing unique keys to all values implicitly.
