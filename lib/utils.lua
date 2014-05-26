local Object = require('core').Object
local String = require('string')
local Os     = require('os')
local Clock  = require('clocktime')
local Utils  = require('utils')

local utils = Object:extend()

local Levels = {
  ['error'] = {value = 0, name = 'ERROR'},
  ['warn']  = {value = 1, name = 'WARN'},
  ['info']  = {value = 2, name = 'INFO'},
  ['debug'] = {value = 3, name = 'DEBUG'},
  ['trace'] = {value = 4, name = 'TRACE'}
}
utils.Levels = Levels

function utils.formatDate(format)
  if format then
    return Os.date(format)
  else
    local s, ms, ns = Clock.time()

    return Os.date('![%Y-%m-%d][%H:%M:%S.' .. String.format("%03.0f", ms) .. ']', s)
  end
end

function utils.formatLevel(level)
  return '[' .. String.format("%-5s", level.name) .. ']'
end

function utils.finalString(format, level, s, ...)

  return utils.formatDate(format) 
        .. utils.formatLevel(level) 
        .. ' ' 
        .. String.format(s, ...) 

end

return utils
