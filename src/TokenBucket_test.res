open Jest
open Expect

type request = string // for now this is going to be a string
type handlingResult = Result.t<unit, unit> // for now, just a simple result with no data inside
type handleRequest = (request) => handlingResult

let handleRequest: handleRequest = (_request) => Error()

describe("Token Bucket Algorithm", () => {
  test("When a request arrives and the bucket is empty, the request is declined", () => {
    let request = "some.ip"
    request->handleRequest->expect->toEqual(Error())
  })
})
