parameter save_first.

run kdb.

if save_first {
  set myDB to lexicon().
  set myDB["coolNames"] to list(
    "Kevin",
    "Jack",
    "Alice",
    "Bob"
  ).
  set myDB["nestedLex"] to lexicon().
  set myDB["nestedLex"]["myQueue"] to queue().
  set myDB["nestedLex"]["myStack"] to stack().
  myDB["nestedLex"]["myQueue"]:push(list(1,2,3)).
  myDB["nestedLex"]["myQueue"]:push("what?").
  myDB["nestedLex"]["myStack"]:push(5).
  myDB["nestedLex"]["myStack"]:push("foo").
  myDB["nestedLex"]["myStack"]:push("bar").

  kdb_save("myDB", myDB).
}

print kdb_load("myDB"):dump.
