module InMemoryStore = {
  type initialValue = int
  type t = (Js.Dict.t<int>, initialValue)
  let make = (~initialValue): t => {
    let tokensDict = Dict.fromArray([])
    (tokensDict, initialValue)
  }

  let get = async ((tokensDict, initialValue), identifier) => {
    switch tokensDict->Dict.get(identifier) {
    | None =>
      tokensDict->Dict.set(identifier, initialValue)
      initialValue
    | Some(tokens) => tokens
    }
  }

  let set = async ((tokensDict, _), identifier, value) => {
    tokensDict->Dict.set(identifier, value)
  }
}
