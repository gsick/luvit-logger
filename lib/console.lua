local Object   = require('core').Object
local String   = require('string')
local LuvUtils = require('utils')
local Levels   = require('./utils').Levels
local Utils    = require('./utils')

local ConsoleLogger = Object:extend()

function ConsoleLogger:initialize(options)

  self.type = options.type

  self.level = nil
  if type(options.level) == 'string' and Levels[String.lower(options.level)] then
    self.level = Levels[String.lower(options.level)]
  end

  self.dateformat = nil
  if options.dateformat and type(options.dateformat) == 'string' then
    self.dateformat = options.dateformat
  end
  
  self.color = options.color or false

end

function ConsoleLogger:log(parent_level, level, s, ...)

  local final_level = self.level or parent_level

  if level.value > final_level.value then
    return
  end
  
  local final_string = Utils.finalString(self.dateformat, level, s, ...)
  if self.color then
    if level.value == Levels['error'].value then
      print(LuvUtils.colorize('red', final_string))
    elseif level.value == Levels['warn'].value then
      print(LuvUtils.colorize('yellow', final_string))
    elseif level.value == Levels['info'].value then
      print(final_string)
    elseif level.value == Levels['debug'].value then
      print(LuvUtils.colorize('green', final_string))
    elseif level.value == Levels['trace'].value then
      print(LuvUtils.colorize('cyan', final_string))
    end
  else 
    print(final_string)
  end
end

function ConsoleLogger:close()

end

return ConsoleLogger
