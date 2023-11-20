// private API, hide with interface file
// public store will not expose the increment fn
type store = {
  decrement: string => Promise.t<unit>,
  increment: string => Promise.t<unit>,
  get: string => Promise.t<int>,
}

// public API
type request = string // for now this is going to be a string
type requestResult = Result.t<unit, unit> // for now, just a simple result with no data inside
type handleRequest = request => Promise.t<requestResult>
type bucket = handleRequest // right now, to the outside viewer, the bucket is just the ability to handle a request
type makeBucket = (~store: store) => bucket

let makeBucket: makeBucket = (~store, request) => {
  store.get(request)->Promise.then(tokens =>
    switch tokens {
    | 0 => Promise.resolve(Error())
    | _ => store.decrement(request)->Promise.thenResolve(_ => Ok())
    }
  )
}

module InMemoryStore = {
  let make = (~initialValue) => {
    let tokensDict = Dict.fromArray([])
    let decrement = async identifier => {
      switch tokensDict->Dict.get(identifier) {
      | None
      | Some(0) => ()
      | Some(tokens) => tokensDict->Dict.set(identifier, tokens - 1)
      }
    }
    let increment = async identifier => {
      switch tokensDict->Dict.get(identifier) {
      | None => tokensDict->Dict.set(identifier, initialValue)
      | Some(tokens) => tokensDict->Dict.set(identifier, tokens + 1)
      }
    }
    let get = async identifier => {
      switch tokensDict->Dict.get(identifier) {
      | None =>
        tokensDict->Dict.set(identifier, initialValue)
        initialValue
      | Some(tokens) => tokens
      }
    }
    {decrement, increment, get}
  }
}
