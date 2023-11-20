// private API, hide with interface file
// public store will not expose the increment fn
type store = {
  decrement: () => Promise.t<unit>,
  increment: () => Promise.t<unit>,
  get: () => Promise.t<int>,
}

// public API
type request = string // for now this is going to be a string
type requestResult = Result.t<unit, unit> // for now, just a simple result with no data inside
type handleRequest = (request) => Promise.t<requestResult>
type bucket = handleRequest // right now, to the outside viewer, the bucket is just the ability to handle a request
type makeBucket = (~store: store) => bucket

let makeBucket: makeBucket = (~store) => (_request) => {
  store.get()->Promise.then(tokens => switch tokens {
  | 0 =>
    Promise.resolve(Error())
  | _ =>
    store.decrement()->Promise.thenResolve(_ => Ok())
  })
}

module InMemoryStore = {
  let make = (~initialValue) => {
    let tokens = ref(initialValue)
    let decrement = async () => {
      tokens := tokens.contents - 1
    }
    let increment = async () => {
      tokens := tokens.contents + 1
    }
    let get = () => Promise.resolve(tokens.contents)
    {decrement, increment, get}
  }
}
