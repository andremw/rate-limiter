open Express

let app = expressCjs()
app->get("/unlimited", (_, res) => {
  let _ = res->status(200)->send("Unlimited! Let's go!")
})
app->get("/limited", (_, res) => {
  let _ = res->status(200)->send("Limited, don't over use me!")
})

let _ = app->listen(8080)
