// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Jest = require("@glennsl/rescript-jest/src/jest.bs.js");
var Curry = require("rescript/lib/js/curry.js");
var Store = require("./Store.bs.js");
var Core__Array = require("@rescript/core/src/Core__Array.bs.js");
var TokenBucket = require("./TokenBucket.bs.js");

function inSeries(ops) {
  return Core__Array.reduce(ops, Promise.resolve([]), (function (chain, asyncOp) {
                return chain.then(function (previousResults) {
                            return Curry._1(asyncOp, undefined).then(function (currentResult) {
                                        return Promise.resolve(previousResults.concat([currentResult]));
                                      });
                          });
              }));
}

Jest.describe("Token Bucket Algorithm", (function (param) {
        Jest.describe("When a request arrives and the bucket contains tokens, the request is handled and a token is removed from the bucket", (function (param) {
                Jest.testPromise("Handles request from single IP", undefined, (function (param) {
                        var store = Store.InMemoryStore.make(1);
                        var request = "ip.1";
                        var handleRequest = function (param) {
                          return TokenBucket.makeBucket(store, Store.InMemoryStore.get, Store.InMemoryStore.set, param);
                        };
                        return inSeries([
                                      (function (param) {
                                          return handleRequest(request);
                                        }),
                                      (function (param) {
                                          return handleRequest(request);
                                        })
                                    ]).then(function (handleResults) {
                                    return Jest.Expect.toEqual(Jest.Expect.expect(handleResults), [
                                                {
                                                  TAG: /* Ok */0,
                                                  _0: undefined
                                                },
                                                {
                                                  TAG: /* Error */1,
                                                  _0: undefined
                                                }
                                              ]);
                                  });
                      }));
                Jest.testPromise("Handles requests from different IPs, decrementing each of their token buckets", undefined, (function (param) {
                        var store = Store.InMemoryStore.make(1);
                        var requestIP1 = "ip.1";
                        var handleRequest = function (param) {
                          return TokenBucket.makeBucket(store, Store.InMemoryStore.get, Store.InMemoryStore.set, param);
                        };
                        return inSeries([
                                      (function (param) {
                                          return handleRequest(requestIP1);
                                        }),
                                      (function (param) {
                                          return handleRequest("ip.2");
                                        }),
                                      (function (param) {
                                          return handleRequest(requestIP1);
                                        })
                                    ]).then(function (handleResults) {
                                    return Jest.Expect.toEqual(Jest.Expect.expect(handleResults), [
                                                {
                                                  TAG: /* Ok */0,
                                                  _0: undefined
                                                },
                                                {
                                                  TAG: /* Ok */0,
                                                  _0: undefined
                                                },
                                                {
                                                  TAG: /* Error */1,
                                                  _0: undefined
                                                }
                                              ]);
                                  });
                      }));
              }));
        Jest.testPromise("When a request arrives and the bucket is empty, the request is declined", undefined, (function (param) {
                var store = Store.InMemoryStore.make(0);
                var handleRequest = function (param) {
                  return TokenBucket.makeBucket(store, Store.InMemoryStore.get, Store.InMemoryStore.set, param);
                };
                return handleRequest("some.ip").then(function (handleResult) {
                            return Jest.Expect.toEqual(Jest.Expect.expect(handleResult), {
                                        TAG: /* Error */1,
                                        _0: undefined
                                      });
                          });
              }));
      }));

exports.inSeries = inSeries;
/*  Not a pure module */
