local Object = require('core').Object
local String = require('string')
local Clock  = require('clocktime')
local Utils  = require('utils')

local Conf          = require('./conf')
local FileLogger    = require('./file')
local ConsoleLogger = require('./console')
local RedisLogger   = require('./redis')
local SyslogLogger  = require('./syslog')
local Levels        = require('./utils').Levels

local _Logger = Object:extend()

function _Logger:initialize(options)

  self.name = options.name
  
  self.level = options.level and Levels[String.lower(options.level)] or Levels['error']
  self.dateformat = nil
  if options.dateformat and type(options.dateformat) == 'string' then
    self.dateformat = options.dateformat
  end
  
  self.loggers = {}
  if type(options.loggers) ~= 'table' then
    error('Loggers: ' .. Utils.dump(options.loggers) .. ' is not a table')
  end
  for index, value in ipairs(options.loggers) do

    local logger
    local options = value
    if type(options.type) ~= 'string' then
      error('logger type: ' .. Utils.dump(options.type) .. ' is not a string')
    end
    
    if not options.dateformat then
      options.dateformat = self.dateformat
    end
    
    if options.type == 'file' then
      logger = FileLogger:new(options)
    elseif options.type == 'console' then
      logger = ConsoleLogger:new(options)
    elseif options.type == 'redis' then
      logger = RedisLogger:new(options)
    elseif options.type == 'syslog' then
      logger = SyslogLogger:new(options)
    else
      error('logger type: ' .. Utils.dump(options.type) 
        .. ' should be \"file\", \"console\", \"redis\" or \"syslog\"')
    end
  
    self.loggers[index] = logger
  end
  
  
end

function _Logger:getName()
  return self.name
end

function _Logger:setLevel(level)
  if type(level) == 'string' and Levels[String.lower(level)] ~= nil then
    self.level = Levels[String.lower(level)]
  elseif level == Levels['error'] or level == Levels['warn']
          or level == Levels['info'] or level == Levels['debug']
          or level == Levels['trace'] then
    self.level = level
  end
end

function _Logger:getLevel()
  return self.level
end

function _Logger:log(level, s, ...)
  if type(level) ~= 'table' or type(s) ~= 'string' then
    return
  end

  for key, value in pairs(self.loggers) do
    value:log(self.level, level, s, ...)
  end
end

for key,value in pairs(Levels) do 
  _Logger[key] = function(self, ...)
    self:log(Levels[key], ...)
  end
end

function _Logger:close()
  for i, value in ipairs(self.loggers) do
    value:close()
  end
end

local _loggers = {}

local Logger = Object:extend()

Logger.ERROR = Levels['error']
Logger.WARN  = Levels['warn']
Logger.INFO  = Levels['info']
Logger.DEBUG = Levels['debug']
Logger.TRACE = Levels['trace']

function Logger:initialize(path)
  local conf = Conf:new(path)
  local json = conf:read()
  
  for key, value in pairs(json) do
  
    local options = value
    if type(options.name) ~= 'string' then
      error('logger name: ' .. Utils.dump(options.name) .. ' is not a string')
    end
    
    _loggers[options.name] = _Logger:new(options)
  end
end

function Logger.getLogger(name)
  if not _loggers[name] then
    error('Logger \"' .. name .. '\" not initialized')
  end
  return _loggers[name]
end

function Logger.close()
  for key, value in pairs(_loggers) do
    _loggers[key]:close()
    _loggers[key] = nil
  end
end

return Logger
