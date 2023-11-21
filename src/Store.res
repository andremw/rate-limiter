// private API, hide with interface file
// public store will not expose the increment fn
type t = {
  decrement: string => Promise.t<unit>,
  increment: string => Promise.t<unit>,
  get: string => Promise.t<int>,
}

module InMemoryStore = {
  let make = (~initialValue) => {
    let tokensDict = Dict.fromArray([])
    let decrement = async identifier => {
      switch tokensDict->Dict.get(identifier) {
      | None
      | Some(0) => ()
      | Some(tokens) => tokensDict->Dict.set(identifier, tokens - 1)
      }
    }
    let increment = async identifier => {
      switch tokensDict->Dict.get(identifier) {
      | None => tokensDict->Dict.set(identifier, initialValue)
      | Some(tokens) => tokensDict->Dict.set(identifier, tokens + 1)
      }
    }
    let get = async identifier => {
      switch tokensDict->Dict.get(identifier) {
      | None =>
        tokensDict->Dict.set(identifier, initialValue)
        initialValue
      | Some(tokens) => tokens
      }
    }
    {decrement, increment, get}
  }
}
