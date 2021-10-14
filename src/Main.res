module User = {
  open Table

  type user = {
    name: string,
    tenure: int,
  }

  let table: t<user> = Store.make()->make(0)

  let insert = table->insert
  let find = table->find
  let filter = table->filter
}

let result = User.insert(1, {name: "Joel", tenure: 4})

let user = User.find(1)
let tenured = User.filter(user => user.tenure > 2)
