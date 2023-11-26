// public API
type request = string // for now this is going to be a string
type requestResult = Result.t<unit, unit> // for now, just a simple result with no data inside
type handleRequest = request => Promise.t<requestResult>
type bucket = handleRequest // right now, to the outside viewer, the bucket is just the ability to handle a request

let makeBucket = (
  ~store,
  ~get,
  ~set,
  request,
) => {
  store->get(request)
  ->Promise.then(tokens =>
    switch tokens {
    | 0 => Promise.resolve(Error())
    | tokens => store->set(request, tokens - 1)->Promise.thenResolve(_ => Ok())
    }
  )
}
