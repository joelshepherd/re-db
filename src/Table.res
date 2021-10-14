type t<'a> = {
  path: int,
  store: Store.t<'a>,
}

let make = (store, path) => {
  path: path,
  store: store,
}

let find = (table, id) => table.store->Store.get(list{table.path, id})

let filter = (table, predicate) =>
  table.store
  ->Store.scan(list{table.path})
  ->Belt.Option.getWithDefault([])
  ->Belt.Array.keep(predicate)

let insert = (table, id, row) => table.store->Store.put(list{table.path, id}, row)

// module Test = {
//   let store = Store.make()
//   let table = make(store, 1)
//   assert (table->insert(1, "Test"))
//   assert (table->filter(_ => true) == ["Test"]) // assert missing keys are not added
// }
