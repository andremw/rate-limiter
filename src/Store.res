// private API, hide with interface file
// public store will not expose the increment fn
module type StoreDefinition = {
  type t
  let make: (~initialValue: int) => t
  let get: (t, string) => Promise.t<int>
  let decrement: (t, string) => Promise.t<unit>
  let increment: (t, string) => Promise.t<unit>
}

module InMemoryStore = {
  type initialValue = int
  type t = (Js.Dict.t<int>, initialValue)
  let make = (~initialValue): t => {
    let tokensDict = Dict.fromArray([])
    (tokensDict, initialValue)
  }

  let decrement = async ((tokensDict, _), identifier) => {
    switch tokensDict->Dict.get(identifier) {
    | None
    | Some(0) => ()
    | Some(tokens) => tokensDict->Dict.set(identifier, tokens - 1)
    }
  }

  let increment = async ((tokensDict, initialValue), identifier) => {
    switch tokensDict->Dict.get(identifier) {
    | None => tokensDict->Dict.set(identifier, initialValue)
    | Some(tokens) => tokensDict->Dict.set(identifier, tokens + 1)
    }
  }

  let get = async ((tokensDict, initialValue), identifier) => {
    switch tokensDict->Dict.get(identifier) {
    | None =>
      tokensDict->Dict.set(identifier, initialValue)
      initialValue
    | Some(tokens) => tokens
    }
  }
}
