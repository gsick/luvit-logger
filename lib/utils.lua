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

function utils.formatDate(dateformat)
  if dateformat then
    return Os.date(dateformat)
  else
    local s, ms, ns = Clock.time()

    return Os.date('![%Y-%m-%d][%H:%M:%S.' .. String.format("%03.0f", ms) .. ']', s)
  end
end

function utils.formatLevel(level)
  return '[' .. String.format("%-5s", level.name) .. ']'
end

function utils.finalStringWithoutDate(level, s, ...)

  return utils.formatLevel(level) 
        .. ' ' 
        .. String.format(s, ...)
end

function utils.finalString(dateformat, level, s, ...)

  return utils.formatDate(dateformat) 
        .. utils.formatLevel(level) 
        .. ' ' 
        .. String.format(s, ...)
end

return utils
