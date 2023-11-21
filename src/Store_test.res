open Jest
open Expect

open Store

describe("InMemoryStore", () => {
  testPromise("get", () => {
    let store = InMemoryStore.make(~initialValue=10)
    store->InMemoryStore.get("id123")->Promise.thenResolve(value => value->expect->toEqual(10))
  })
})
