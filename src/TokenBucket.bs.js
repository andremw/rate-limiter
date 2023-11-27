// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var Utils = require("./Utils.bs.js");

function makeBucket(store, getTime, initialTokens, request) {
  return Curry._1(store.get, request).then(function (data) {
              if (data === undefined) {
                if (initialTokens > 0) {
                  return Curry._2(store.set, request, {
                                requests: 1,
                                firstRequestAt: Curry._1(getTime, undefined)
                              }).then(function (param) {
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
              }
              var firstRequestAt = data.firstRequestAt;
              var requests = data.requests;
              var maxRequests = initialTokens + Utils.timeDiffInSeconds(new Date(Curry._1(getTime, undefined)), new Date(firstRequestAt)) | 0;
              if ((maxRequests - requests | 0) > 0) {
                return Curry._2(store.set, request, {
                              requests: requests + 1 | 0,
                              firstRequestAt: firstRequestAt
                            }).then(function (param) {
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
