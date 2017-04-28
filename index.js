hex_code63 = function (n) {
  return(number_code63(n) || n > 96 && n < 103 || n > 64 && n < 71);
};
var hex_char63 = function (s, i) {
  var c = code(s, i);
  var _x8 = c;
  if (117 === _x8 || 85 === _x8) {
    return(i === edge(s));
  } else {
    if (120 === _x8 || 88 === _x8) {
      return(i === 1);
    } else {
      if (48 === _x8) {
        return(!( i === 1));
      } else {
        return(i >= 2 && hex_code63(c));
      }
    }
  }
};
hexadecimal63 = function (s) {
  var n = _35(s);
  var i = 0;
  while (i < n) {
    if (! hex_char63(s, i)) {
      return(false);
    }
    i = i + 1;
  }
  return(n > 2);
};
var number_suffix63 = function (s) {
  var c = code(s, edge(s));
  return(c === 117 || c === 85);
};
var number_normalize = function (s) {
  if (number_suffix63(s)) {
    return(clip(s, 0, edge(s)));
  } else {
    return(s);
  }
};
var maybe_number63 = function (s) {
  return(some63(s) && (number_code63(code(s, edge(s))) || hexadecimal63(s)));
};
var maybe_number = function (s) {
  if (string63(s)) {
    var _s = number_normalize(s);
    if (maybe_number63(_s)) {
      return(number(_s));
    }
  }
};
var real63 = function (x) {
  return(number63(x) && ! nan63(x) && ! inf63(x));
};
number = function (s) {
  var _s1 = number_normalize(s);
  var _e;
  if (hexadecimal63(_s1)) {
    _e = parseInt(_s1, 16);
  } else {
    _e = parseFloat(_s1);
  }
  var n = _e;
  if (! isNaN(n)) {
    return(n);
  }
};
var _e1;
if (typeof(lumen_shim_hex) === "undefined") {
  _e1 = require("reader")["read-table"][""];
} else {
  _e1 = lumen_shim_hex["old-read-atom"];
}
var old_read_atom = _e1;
var read_atom = function (s) {
  var x = old_read_atom(s);
  var n = maybe_number(x);
  if (real63(n)) {
    return(n);
  } else {
    return(x);
  }
};
if (typeof(lumen_shim_hex) === "undefined") {
  require("reader")["read-table"][""] = read_atom;
  lumen_shim_hex = {"old-read-atom": old_read_atom};
}
exports["hex-code?"] = hex_code63;
exports["hex-char?"] = hex_char63;
exports["hexadecimal?"] = hexadecimal63;
exports["number-suffix?"] = number_suffix63;
exports["number-normalize"] = number_normalize;
exports["maybe-number?"] = maybe_number63;
exports["maybe-number"] = maybe_number;
exports["real?"] = real63;
exports.number = number;
exports["old-read-atom"] = old_read_atom;
exports["read-atom"] = read_atom;
