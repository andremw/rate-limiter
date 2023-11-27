open Jest
open Expect

open TokenBucket
open Store

module NaturalNumber = Utils.NaturalNumber

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

let unpackOptionalDependency = (value: option<'a>, fn) => switch value {
| Some(value) => fn(value)
| None => raise(Js.Exn.raiseError("Should never happen"))
}

describe("Token Bucket Algorithm", () => {
  describe(
    "When a request arrives and the bucket contains tokens, the request is handled and a token is removed from the bucket",
    () => {
      testPromise(
        "Handles request from single IP",
        () => {
          let store = InMemoryStore.make()

          let request = "ip.1"
          let getTime = () => 1000.0
          let capacity = 1->NaturalNumber.make
          capacity->unpackOptionalDependency((capacity) => {
            let handleRequest = makeBucket(~store, ~getTime, ~capacity)

            [() => request->handleRequest, () => request->handleRequest]
            ->inSeries
            ->Promise.thenResolve(
              handleResults => {
                handleResults->expect->toEqual([Ok(), Error()])
              },
            )
          })
        },
      )

      testPromise(
        "Handles requests from different IPs, decrementing each of their token buckets",
        () => {
          let store = InMemoryStore.make()

          let requestIP1 = "ip.1"
          let requestIP2 = "ip.2"
          let getTime = () => 1000.0
          let capacity = 1->NaturalNumber.make
          capacity->unpackOptionalDependency((capacity) => {
            let handleRequest = makeBucket(~store, ~getTime, ~capacity)

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
          })
        },
      )
    },
  )

  testPromise("Refils 1 token per second", () => {
    let store = InMemoryStore.make()
    let request = "some.ip"
    let mockFn = JestJs.inferred_fn()
    let fn = MockJs.fn(mockFn)
    let _timeAtTheFirstSecond = mockFn->MockJs.mockReturnValueOnce(Js.Undefined.return(1000.0))
    let _timeBefore2Seconds = mockFn->MockJs.mockReturnValueOnce(Js.Undefined.return(1200.0))
    let _timeAfter2Seconds = mockFn->MockJs.mockReturnValueOnce(Js.Undefined.return(2000.0))
    let getTime = () => fn(.())->Js.Undefined.toOption->Option.getOr(0.0)
    let capacity = 1->NaturalNumber.make
    capacity->unpackOptionalDependency((capacity) => {
      let handleRequest = makeBucket(~store, ~getTime, ~capacity)

      [() => request->handleRequest, () => request->handleRequest, () => request->handleRequest]
      ->inSeries
      ->Promise.thenResolve(
        results => {
          results->expect->toEqual([Ok(), Error(), Ok()])
        },
      )
    })
  })
})
