#!/usr/bin/env lua

--[[

Author: Peter Odding <peter@peterodding.com>
Last Change: July 12, 2014
URL: http://peterodding.com/code/vim/lua-ftplugin

This Lua script is executed by the Lua file type plug-in for Vim to provide
dynamic completion of function names defined by installed Lua modules. This
works by expanding package.path and package.cpath in Vim script, loading every
module found on the search path into this Lua script and then dumping the
global state.

]]

local keywords = { ['and'] = true, ['break'] = true, ['do'] = true,
  ['else'] = true, ['elseif'] = true, ['end'] = true, ['false'] = true,
  ['for'] = true, ['function'] = true, ['if'] = true, ['in'] = true,
  ['local'] = true, ['nil'] = true, ['not'] = true, ['or'] = true,
  ['repeat'] = true, ['return'] = true, ['then'] = true, ['true'] = true,
  ['until'] = true, ['while'] = true }

local function isident(s)
  return type(s) == 'string' and s:find('^[A-Za-z_][A-Za-z_0-9]*$') and not keywords[s]
end

local function addmatch(word, kind, desc)
  if not desc then
    print(string.format("{'word':'%s','kind':'%s'}", word, kind))
  else
    -- Make sure we generate valid Vim script expressions (this is probably
    -- still not right).
    desc = desc:gsub('\n', '\\n')
               :gsub('\r', '\\r')
               :gsub("'", "''")
    print(string.format("{'word':'%s','kind':'%s','menu':'%s'}", word, kind, desc))
  end
end

local function dump(table, path, cache)
  local printed = false
  for key, value in pairs(table) do
    if isident(key) then
      local path = path and (path .. '.' .. key) or key
      local vtype = type(value)
      if vtype == 'function' then
        printed = true
        addmatch(path, 'f', path .. '()')
      elseif vtype ~= 'table' then
        printed = true
        if vtype == 'boolean' or vtype == 'number' then
          addmatch(path, 'v', tostring(value))
        elseif vtype == 'string' then
          if #value > 40 then
            value = value:sub(1, 40) .. '..'
          end
          addmatch(path, 'v', value)
        else
          addmatch(path, 'v', nil)
        end
      elseif not cache[value] then
        cache[value] = true
        if dump(value, path, cache) then
          printed = true
        else
          addmatch(path, 't', path .. '[]')
        end
      end
    end
  end
  return printed
end

-- Add keywords to completion candidates.
for kw, _ in pairs(keywords) do
  addmatch(kw, 'k', nil)
end

local function global_exists(name)
  -- Don't crash on strict.lua.
  return pcall(function()
    if not _G[name] then
      -- Simulate strict.lua when it isn't active so that we can stick to a
      -- single code path.
      error("variable " .. name .. " is not declared")
    end
  end)
end

-- Load installed modules.
-- XXX What if module loading has side effects? It shouldn't, but still...
for i = 1, #arg do
  local modulename = arg[i]
  local status, module = pcall(require, modulename)
  if status and module and not global_exists(modulename) then
    _G[modulename] = module
  end
end

-- Generate completion candidates from global state.
local cache = { [_G] = true, [package.loaded] = true }
local output = {}
dump(_G, nil, cache, output)
