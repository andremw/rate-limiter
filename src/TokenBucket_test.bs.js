// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Jest = require("@glennsl/rescript-jest/src/jest.bs.js");

function makeBucket(param, _request) {
  return {
          TAG: /* Error */1,
          _0: undefined
        };
}

Jest.describe("Token Bucket Algorithm", (function (param) {
        Jest.test("When a request arrives and the bucket is empty, the request is declined", (function (param) {
                return Jest.Expect.toEqual(Jest.Expect.expect({
                                TAG: /* Error */1,
                                _0: undefined
                              }), {
                            TAG: /* Error */1,
                            _0: undefined
                          });
              }));
      }));

exports.makeBucket = makeBucket;
/*  Not a pure module */