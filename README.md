# re-db

An experiment writing an in-memory record database with rescript.

## Usage

```res
module User = {
  type user = {
    name: string,
    tenure: int,
  }

  let table: t<user> = Store.make()->Table.make(0)

  let insert = table->Table.insert
  let find = table->Table.find
  let filter = table->Table.filter
}

// Write
let success = User.insert(1, {name: "Joel", tenure: 4})

// Read
let user = User.find(1)
let tenured = User.filter(user => user.tenure > 2)
```
