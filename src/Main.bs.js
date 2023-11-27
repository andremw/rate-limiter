// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Store = require("./Store.bs.js");
var Express = require("express");
var TokenBucket = require("./TokenBucket.bs.js");

var app = Express();

app.get("/unlimited", (function (param, res) {
        res.status(200).send("Unlimited! Let's go!");
      }));

var partial_arg = Store.InMemoryStore.make(undefined);

function rateLimiter(param) {
  return TokenBucket.makeBucket(partial_arg, (function (param) {
                return Date.now();
              }), 10, param);
}

app.get("/limited", (function (req, res) {
        rateLimiter(req.ip).then(function (result) {
              if (result.TAG === /* Ok */0) {
                return res.status(200).send("Limited, don't over use me!");
              } else {
                return res.status(429).send("Too many requests!");
              }
            });
      }));

app.listen(8080);

exports.app = app;
exports.rateLimiter = rateLimiter;
/* app Not a pure module */
