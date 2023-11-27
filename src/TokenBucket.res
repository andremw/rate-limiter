// public API
type request = string // for now this is going to be a string
type requestResult = Result.t<unit, unit> // for now, just a simple result with no data inside
type handleRequest = request => Promise.t<requestResult>
type bucket = handleRequest // right now, to the outside viewer, the bucket is just the ability to handle a request

open Store.InMemoryStore

let makeBucket = (
  ~store: Store.InMemoryStore.t,
  ~getTime,
  ~initialTokens,
  request,
) => {
  store.get(request)
  ->Promise.then(data =>
    switch data {
    | None =>
      initialTokens > 0
      ? store.set(request, {
        requests: 1,
        firstRequestAt: getTime(),
      })->Promise.thenResolve(_ => Ok())
      : Promise.resolve(Error())
    | Some({ requests, firstRequestAt }) =>
      let maxRequests = initialTokens + Utils.timeDiffInSeconds(Date.fromTime(getTime()), Date.fromTime(firstRequestAt))
      switch maxRequests - requests > 0 {
      | true => store.set(request, { requests: requests + 1, firstRequestAt })->Promise.thenResolve(_ => Ok())
      | false => Promise.resolve(Error())
      }
    }
  )
}
