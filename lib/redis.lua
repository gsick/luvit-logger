local Object = require('core').Object
local String = require('string')
local Redis  = require('redis')
local Levels = require('./utils').Levels
local Utils  = require('./utils')

local function _noop(err, res) 
  if err then
    error('Logger Redis: ' .. err)
  end
end

local RedisLogger = Object:extend()

function RedisLogger:initialize(options)

  self.type = options.type

  self.level = nil
  if type(options.level) == 'string' and Levels[String.lower(options.level)] then
    self.level = Levels[String.lower(options.level)]
  end

  self.dateformat = nil
  if options.dateformat and type(options.dateformat) == 'string' then
    self.dateformat = options.dateformat
  end
  
  if not options.host or type(options.host) ~= 'string' then
    error('Logger redis: host must be defined')
  end
  self.host = options.host
  
  if options.port and type(options.port) ~= 'number' then
    error('Logger redis: port must be a number')
  end
  self.port = options.port
  
  if not options.cmd or type(options.cmd) ~= 'string' then
    error('Logger redis: a command must be defined')
  end
  self.cmd = options.cmd

  if not options.key or type(options.key) ~= 'string' then
    error('Logger redis: a key must be defined')
  end
  self.key = options.key
  
  self.reconnect = options.reconnect or false
  self.date = options.date

  self.client = Redis:new(self.host, self.port, self.reconnect)
end

function RedisLogger:log(parent_level, level, s, ...)

  local final_level = self.level or parent_level

  if level.value <= final_level.value then
    if not self.date then
      self.client:command(self.cmd, self.key, Utils.finalStringWithoutDate(level, s, ...), _noop)
    else
      self.client:command(self.cmd, self.key, Utils.finalString(self.dateformat, level, s, ...), _noop)
    end
  end

end

function RedisLogger:close()
  self.client:disconnect()
end

return RedisLogger
