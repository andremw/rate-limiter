// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Jest = require("@glennsl/rescript-jest/src/jest.bs.js");
var Utils = require("./Utils.bs.js");

Jest.test("timeDiffInSeconds", (function (param) {
        var date1 = new Date(2023, 10, 21, 12, 0, 0);
        var date2 = new Date(2023, 10, 21, 12, 0, 10);
        return Jest.Expect.toBe(Jest.Expect.expect(Utils.timeDiffInSeconds(date1, date2)), 10);
      }));

Jest.test("limit", (function (param) {
        return Jest.Expect.toBe(Jest.Expect.expect(Utils.limitTo(10, 100)), 10);
      }));

/*  Not a pure module */
