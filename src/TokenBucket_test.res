open Jest
open Expect

open TokenBucket

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
