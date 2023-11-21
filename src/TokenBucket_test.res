open Jest
open Expect

open TokenBucket
open Store

let inSeries = (ops: array<unit => Promise.t<'a>>): Promise.t<array<'a>> => {
  ops->Array.reduce(Promise.resolve([]), (chain, asyncOp) => {
    chain->Promise.then(previousResults => {
      asyncOp()->Promise.then(
        currentResult => {
          Promise.resolve(Array.concat(previousResults, [currentResult]))
        },
      )
    })
  })
}

describe("Token Bucket Algorithm", () => {
  describe(
    "When a request arrives and the bucket contains tokens, the request is handled and a token is removed from the bucket",
    () => {
      testPromise(
        "Handles request from single IP",
        () => {
          let store = InMemoryStore.make(~initialValue=1)

          let request = "ip.1"
          let handleRequest = makeBucket(module(InMemoryStore), ~store)

          [() => request->handleRequest, () => request->handleRequest]
          ->inSeries
          ->Promise.thenResolve(
            handleResults => {
              handleResults->expect->toEqual([Ok(), Error()])
            },
          )
        },
      )

      testPromise(
        "Handles requests from different IPs, decrementing each of their token buckets",
        () => {
          let store = InMemoryStore.make(~initialValue=1)

          let requestIP1 = "ip.1"
          let requestIP2 = "ip.2"
          let handleRequest = makeBucket(module(InMemoryStore), ~store)

          [
            () => requestIP1->handleRequest,
            () => requestIP2->handleRequest,
            () => requestIP1->handleRequest,
          ]
          ->inSeries
          ->Promise.thenResolve(
            handleResults => {
              handleResults->expect->toEqual([Ok(), Ok(), Error()])
            },
          )
        },
      )
    },
  )

  testPromise("When a request arrives and the bucket is empty, the request is declined", () => {
    let store = InMemoryStore.make(~initialValue=0)
    let request = "some.ip"
    let handleRequest = makeBucket(module(InMemoryStore), ~store)
    request
    ->handleRequest
    ->Promise.thenResolve(
      handleResult => {
        handleResult->expect->toEqual(Error())
      },
    )
  })
})
