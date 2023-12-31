// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';


function make(param) {
  var dict = Object.fromEntries([]);
  return {
          get: (function (key) {
              return Promise.resolve(dict[key]);
            }),
          set: (function (key, value) {
              dict[key] = value;
              return Promise.resolve(undefined);
            })
        };
}

var InMemoryStore = {
  make: make
};

exports.InMemoryStore = InMemoryStore;
/* No side effect */
