function hex_code63(n)
  return(number_code63(n) or n > 96 and n < 103 or n > 64 and n < 71)
end
local function hex_char63(s, i)
  local c = code(s, i)
  local _x8 = c
  if 117 == _x8 or 85 == _x8 then
    return(i == edge(s))
  else
    if 120 == _x8 or 88 == _x8 then
      return(i == 1)
    else
      if 48 == _x8 then
        return(not( i == 1))
      else
        return(i >= 2 and hex_code63(c))
      end
    end
  end
end
function hexadecimal63(s)
  local n = _35(s)
  local i = 0
  while i < n do
    if not hex_char63(s, i) then
      return(false)
    end
    i = i + 1
  end
  return(n > 2)
end
local function number_suffix63(s)
  local c = code(s, edge(s))
  return(c == 117 or c == 85)
end
local function number_normalize(s)
  if number_suffix63(s) then
    return(clip(s, 0, edge(s)))
  else
    return(s)
  end
end
local function maybe_number63(s)
  return(some63(s) and (number_code63(code(s, edge(s))) or hexadecimal63(s)))
end
local function maybe_number(s)
  if string63(s) then
    local _s = number_normalize(s)
    if maybe_number63(_s) then
      return(number(_s))
    end
  end
end
local function real63(x)
  return(number63(x) and not nan63(x) and not inf63(x))
end
function number(s)
  local _s1 = number_normalize(s)
  return(tonumber(_s1))
end
local _e
if lumen_shim_hex == nil then
  _e = require("reader")["read-table"][""]
else
  _e = lumen_shim_hex["old-read-atom"]
end
local old_read_atom = _e
local function read_atom(s)
  local x = old_read_atom(s)
  local n = maybe_number(x)
  if real63(n) then
    return(n)
  else
    return(x)
  end
end
if lumen_shim_hex == nil then
  require("reader")["read-table"][""] = read_atom
  lumen_shim_hex = {["old-read-atom"] = old_read_atom}
end
return({["hex-code?"] = hex_code63, ["hex-char?"] = hex_char63, ["hexadecimal?"] = hexadecimal63, ["number-suffix?"] = number_suffix63, ["number-normalize"] = number_normalize, ["maybe-number?"] = maybe_number63, ["maybe-number"] = maybe_number, ["real?"] = real63, number = number, ["old-read-atom"] = old_read_atom, ["read-atom"] = read_atom})
