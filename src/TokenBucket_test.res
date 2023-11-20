open Jest
open Expect

type request = string // for now this is going to be a string
type requestResult = Result.t<unit, unit> // for now, just a simple result with no data inside
type handleRequest = (request) => requestResult
type makeBucket = () => handleRequest

let makeBucket: makeBucket = () => (_request) => Error()

describe("Token Bucket Algorithm", () => {
  test("When a request arrives and the bucket is empty, the request is declined", () => {
    let request = "some.ip"
    let handleRequest = makeBucket()
    request->handleRequest->expect->toEqual(Error())
  })
})
