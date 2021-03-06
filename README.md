# direct-sqlite-iss67

This is a repo for [Issue
#67](https://github.com/IreneKnapp/direct-sqlite/issues/67) on direct-sqlite.

Point `stack.yaml` to

* `stack.yaml.lts96` to build with direct-sqlite-2.3.20
  from Stackage LTS 9.6.
* `stack.yaml.fts5` to build with a
  [fork](https://github.com/dunnl/direct-sqlite) of direct-sqlite built with
  -DSQLITE_ENABLE_FTS5 and a 3.15 amalgamation
* `stack.yaml.320.fts5` to build with a
  [branch](https://github.com/dunnl/direct-sqlite/tree/sqlite-3.20.1-fts5) of
  direct-sqlite built with -DSQLITE_ENABLE_FTS5 and with an updated amalgamation
  file (3.20)
* `stack.yaml.system` to built against your own system's SQLite3 library

## Example

```
ln -s stack.yaml.master stack.yaml
stack build
stack exec direct-sqlite-iss67 -- -f test.db -c GetOptions
stack exec direct-sqlite-iss67 -- -f test.db -c Test
```

should complain about not having the FTS5 module available (as indicated in the
compile options).

```
rm stack.yaml
rm test.db
ln -s stack.yaml.fts5 stack.yaml
stack build
stack exec direct-sqlite-iss67 -- -f test.db -c GetOptions
stack exec direct-sqlite-iss67 -- -f test.db -c Test
```

should complain about MATCH not being available, but the compile options should
show that FTS5 is available.
