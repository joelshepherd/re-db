open Belt
module HashMap = Belt.HashMap.Int

type rec t<'a> = Path(HashMap.t<t<'a>>) | Index(HashMap.t<'a>)

type error = InvalidPath

let make = () => Path(HashMap.make(~hintSize=0))

let rec scan = (store, paths) =>
  switch (store, paths) {
  | (Path(store), list{path, ...paths}) => HashMap.get(store, path)->Option.flatMap(scan(_, paths))
  | (Index(index), list{}) => Some(HashMap.valuesToArray(index))
  | _ => None
  }

let rec get = (store, paths) =>
  switch (store, paths) {
  | (Path(store), list{path, ...paths}) => HashMap.get(store, path)->Option.flatMap(get(_, paths))
  | (Index(index), list{path}) => HashMap.get(index, path)
  | _ => None
  }

let rec put = (store, paths, value) => {
  switch (store, paths) {
  | (Path(store), list{path, ...paths}) =>
    switch HashMap.get(store, path) {
    | Some(store) => put(store, paths, value)
    | None => {
        // insert new node
        let new = if List.length(paths) > 1 {
          make()
        } else {
          Index(HashMap.make(~hintSize=1))
        }
        HashMap.set(store, path, new)
        put(new, paths, value)
      }
    }
  | (Index(index), list{path}) => HashMap.set(index, path, value)->Ok
  | _ => Error(InvalidPath)
  }
}

// TODO: fix key ordering
// // test
// module Test = {
//   let store: t<string> = Path(
//     HashMap.fromArray([
//       (0, Index(HashMap.fromArray([(0, "hello"), (1, "world")]))),
//       (1, Index(HashMap.fromArray([(0, "no"), (1, "way")]))),
//     ]),
//   )

//   // scan()
//   assert (scan(store, list{0}) == Some(["hello", "world"]))
//   assert (scan(store, list{1}) == Some(["no", "way"]))
//   assert (scan(store, list{2}) === None)
//   assert (scan(store, list{0, 0}) === None)

//   // get()
//   assert (get(store, list{0}) == None)
//   assert (get(store, list{0, 0}) == Some("hello"))
//   assert (get(store, list{0, 1}) == Some("world"))
//   assert (get(store, list{0, 2}) == None)
//   assert (get(store, list{0, 3}) == None)
//   assert (get(store, list{0, 0, 0}) == None)
//   assert (get(store, list{1, 0}) == Some("no"))
//   assert (get(store, list{1, 1}) == Some("way"))
//   assert (get(store, list{2}) == None)

//   // put()
//   assert (put(store, list{0}, "new") == false)
//   assert (get(store, list{0}) == None)
//   assert (put(store, list{0, 1}, "new") == true)
//   assert (get(store, list{0, 1}) == Some("new"))
//   assert (put(store, list{0, 1, 0}, "new") == false)
//   assert (get(store, list{0, 1, 0}) == None)
//   assert (put(store, list{0, 2}, "new") == true)
//   assert (get(store, list{0, 2}) == Some("new"))
//   assert (put(store, list{2}, "new") == false) // cannot update a path node
//   assert (get(store, list{2}) == None)
//   assert (put(store, list{2, 0}, "new") == true)
//   assert (get(store, list{2, 0}) == Some("new"))
// }
