open Jest
open Expect

type request = string // for now this is going to be a string
type requestResult = Result.t<unit, unit> // for now, just a simple result with no data inside
type handleRequest = (request) => requestResult
type makeBucket = (~capacity: int) => handleRequest

let makeBucket: makeBucket = (~capacity) => (_request) => {
  switch capacity {
  | 0 => Error()
  | _ => Ok()
  }
}

describe("Token Bucket Algorithm", () => {
  test("When a request arrives and the bucket is empty, the request is declined", () => {
    let request = "some.ip"
    let handleRequest = makeBucket(~capacity=0)
    request->handleRequest->expect->toEqual(Error())
  })
})
