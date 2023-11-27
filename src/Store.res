module InMemoryStore = {
  type data = {
    requests: int,
    firstRequestAt: float,
  }
  type t = {
    get: string => promise<option<data>>,
    set: (string, data) => promise<unit>,
  }
  let make = () => {
    let dict = Dict.fromArray([])
    {
      get: (key) => dict->Dict.get(key)->Promise.resolve,
      set: (key, value) => {
        dict->Dict.set(key, value)
        Promise.resolve()
      },
    }
  }

  let get = async (dict, identifier) =>
    dict->Dict.get(identifier)

  let set = async (dict, identifier, value) => {
    dict->Dict.set(identifier, value)
  }
}
