"use strict";

exports.unsafeIndex = function (m, k) {
  return m[k];
};

exports.lookup_ = function (j) {
    return function (n) {
        return function(k) {
            return function(m) {
                var r=m[k];
                if (r) return j(r);
                else   return n;
            };
        };
    };
};

exports.insert = function (k) {
    return function (v) {
        return function(m) {
            m[k]=v;
            return m;
        };
    };
};

exports.empty = {};

exports.keys = function(m) {
    return Object.keys(m);
};

exports.showStrMap = function(m) {
    return JSON.stringify(m);
};

exports.toUnfoldable_ = function(t) {
    return function(m) {
        var result=[];
        Object.keys(dictionary).forEach(function(key) {
            result.push(t(key)(dictionary[key]));
        });
        return result;
    };
};
