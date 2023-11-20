// private API, hide with interface file
// public store will not expose the increment fn
type store = {
  decrement: () => (),
  increment: () => (),
  get: () => int,
}

// public API
type request = string // for now this is going to be a string
type requestResult = Result.t<unit, unit> // for now, just a simple result with no data inside
type handleRequest = (request) => requestResult
type bucket = handleRequest // right now, to the outside viewer, the bucket is just the ability to handle a request
type makeBucket = (~store: store) => bucket
