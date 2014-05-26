local Object = require('core').Object
local String = require('string')
local Levels = require('./utils').Levels

local SyslogLogger = Object:extend()

function SyslogLogger:initialize(options)

  self.type = options.type

  self.level = nil
  if type(options.level) == 'string' and Levels[String.lower(options.level)] then
    self.level = Levels[String.lower(options.level)]
  end

  self.format = nil
  if options.format and type(options.format) == 'string' then
    self.format = options.format
  end
  
  self.url = options.url
  self.cmd = options.cmd
  self.date = options.date
  
end

function SyslogLogger:log(parent_level, level, s, ...)

  local final_level
  if self.level then
    final_level = self.level
  else
    final_level = parent_level
  end

  if level.value > final_level.value then
    return
  end

end

return SyslogLogger

