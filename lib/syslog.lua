local Object = require('core').Object
local String = require('string')
local Socket = require('dgram').Socket
local Levels = require('./utils').Levels

local function _noop() end

local SyslogLogger = Object:extend()

function SyslogLogger:initialize(options)

  self.type = options.type

  self.level = nil
  if type(options.level) == 'string' and Levels[String.lower(options.level)] then
    self.level = Levels[String.lower(options.level)]
  end

  self.dateformat = nil
  if options.dateformat and type(options.dateformat) == 'string' then
    self.dateformat = options.dateformat
  end
  
  self.url = options.url
  self.cmd = options.cmd
  self.date = options.date
  
  self.port = options.port
  self.host = options.host
  
  self.socket = Socket:new('udp4')
end

function SyslogLogger:log(parent_level, level, s, ...)

  local final_level = self.level or parent_level

  if level.value > final_level.value then
    return
  end

  self.socket:send(s, self.port, self.host, _noop)
end

function SyslogLogger:close()
  self.socket:close()
end

return SyslogLogger

