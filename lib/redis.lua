local Object = require('core').Object
local String = require('string')
local Redis  = require('redis')
local Levels = require('./utils').Levels
local Utils  = require('./utils')

local function _noop() end

local RedisLogger = Object:extend()

function RedisLogger:initialize(options)

  self.type = options.type

  self.level = nil
  if type(options.level) == 'string' and Levels[String.lower(options.level)] then
    self.level = Levels[String.lower(options.level)]
  end

  self.format = nil
  if options.format and type(options.format) == 'string' then
    self.format = options.format
  end
  
  if not options.host or type(options.host) ~= 'string' then
    error('Logger redis, host must be defined')
  end
  self.host = options.host
  
  if options.port and type(options.port) ~= 'number' then
    error('Logger redis, port must be a number')
  end
  self.port = options.port
  
  if not options.cmd or type(options.cmd) ~= 'string' then
    error('Logger redis, a formatted command must be defined')
  end
  self.cmd = options.cmd
  
  self.reconnect = options.reconnect or false
  self.date = options.date
  
  self.client = Redis:new(self.port, self.host, self.reconnect)
end

function RedisLogger:log(parent_level, level, s, ...)

  local final_level
  if self.level then
    final_level = self.level
  else
    final_level = parent_level
  end

  if level.value > final_level.value then
    return
  end

  self.client(self.cmd, Utils.finalString(self.format, level, s, ...), _noop)

end

return RedisLogger
