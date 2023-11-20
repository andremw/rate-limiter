open Jest
open Expect

open TokenBucket

describe("Token Bucket Algorithm", () => {
  testPromise("When a request arrives and the bucket contains tokens, the request is handled and a token is removed from the bucket", () => {
    let store = {
      get: () => Promise.resolve(1),
      decrement: () => Promise.resolve(),
      increment: () => Promise.resolve(),
    }

    let request = "ip.1"
    let handleRequest = makeBucket(~store)
    request->handleRequest->Promise.thenResolve((handleResult) => {
      handleResult->expect->toEqual(Ok())
    })
  })

  testPromise("When a request arrives and the bucket is empty, the request is declined", () => {
    let store = {
      get: async () => 0,
      decrement: async () => (),
      increment: async () => (),
    }
    let request = "some.ip"
    let handleRequest = makeBucket(~store)
    request->handleRequest->Promise.thenResolve((handleResult) => {
      handleResult->expect->toEqual(Error())
    })
  })
})
