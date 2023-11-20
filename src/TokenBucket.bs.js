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

function make(initialValue) {
  var tokensDict = Object.fromEntries([]);
  var decrement = async function (identifier) {
    var tokens = tokensDict[identifier];
    if (tokens !== undefined && tokens !== 0) {
      tokensDict[identifier] = tokens - 1 | 0;
      return ;
    }
    
  };
  var increment = async function (identifier) {
    var tokens = tokensDict[identifier];
    if (tokens !== undefined) {
      tokensDict[identifier] = tokens + 1 | 0;
    } else {
      tokensDict[identifier] = initialValue;
    }
  };
  var get = async function (identifier) {
    var tokens = tokensDict[identifier];
    if (tokens !== undefined) {
      return tokens;
    } else {
      tokensDict[identifier] = initialValue;
      return initialValue;
    }
  };
  return {
          decrement: decrement,
          increment: increment,
          get: get
        };
}

var InMemoryStore = {
  make: make
};

exports.makeBucket = makeBucket;
exports.InMemoryStore = InMemoryStore;
/* No side effect */