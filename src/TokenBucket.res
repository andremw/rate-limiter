// public API
type request = string // for now this is going to be a string
type requestResult = Result.t<unit, unit> // for now, just a simple result with no data inside
type handleRequest = request => Promise.t<requestResult>
type bucket = handleRequest // right now, to the outside viewer, the bucket is just the ability to handle a request

let makeBucket = (
  type store,
  storeModule: module(Store.StoreDefinition with type t = store),
  ~store: store,
  request,
) => {
  let module(S) = storeModule

  store
  ->S.get(request)
  ->Promise.then(tokens =>
    switch tokens {
    | 0 => Promise.resolve(Error())
    | _ => store->S.decrement(request)->Promise.thenResolve(_ => Ok())
    }
  )
}
