open Express

let run = () => {
  let app = expressCjs()
  app->get("/unlimited", (_, res) => {
    let _ = res->status(200)->send("Unlimited! Let's go!")
  })

  Utils.NaturalNumber.make(10)->Option.forEach(capacity => {
    let rateLimiter = TokenBucket.makeBucket(
      ~store=Store.InMemoryStore.make(),
      ~getTime=() => Date.now(),
      ~capacity,
    )
    app->get("/limited", (req, res) => {
      let _ =
        req
        ->ip
        ->rateLimiter
        ->Promise.thenResolve(
          result => {
            switch result {
            | Ok() => res->status(200)->send("Limited, don't over use me!")
            | Error() => res->status(429)->send("Too many requests!")
            }
          },
        )
    })

    let _ = app->listen(8080)
  })
}

run()
