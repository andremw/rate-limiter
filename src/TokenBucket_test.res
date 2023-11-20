open Jest
open Expect

// private API
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

let makeBucket: makeBucket = (~store) => (_request) => {
  switch store.get() {
  | 0 => Error()
  | _ => Ok()
  }
}

describe("Token Bucket Algorithm", () => {
  test("When a request arrives and the bucket contains tokens, the request is handled and a token is removed from the bucket", () => {
    let store = {
      get: () => 1,
      decrement: () => (),
      increment: () => (),
    }

    let request = "ip.1"
    let handleRequest = makeBucket(~store)
    request->handleRequest->expect->toEqual(Ok())
  })

  test("When a request arrives and the bucket is empty, the request is declined", () => {
    let store = {
      get: () => 0,
      decrement: () => (),
      increment: () => (),
    }
    let request = "some.ip"
    let handleRequest = makeBucket(~store)
    request->handleRequest->expect->toEqual(Error())
  })
})
