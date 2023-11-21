// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");

function makeBucket(store, request) {
  return Curry._1(store.get, request).then(function (tokens) {
              if (tokens !== 0) {
                return Curry._1(store.decrement, request).then(function (param) {
                            return {
                                    TAG: /* Ok */0,
                                    _0: undefined
                                  };
                          });
              } else {
                return Promise.resolve({
                            TAG: /* Error */1,
                            _0: undefined
                          });
              }
            });
}

exports.makeBucket = makeBucket;
/* No side effect */
