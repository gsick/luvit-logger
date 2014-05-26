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

  self.format = nil
  if options.format and type(options.format) == 'string' then
    self.format = options.format
  end
  
  self.color = options.color or false

end

function ConsoleLogger:log(parent_level, level, s, ...)

  local final_level = self.level or parent_level

  if level.value > final_level.value then
    return
  end
  
  if self.color then
    if level.value == Levels['error'].value then
      print(LuvUtils.colorize('red', Utils.finalString(self.format, level, s, ...)))
    elseif level.value == Levels['warn'].value then
      print(LuvUtils.colorize('yellow', Utils.finalString(self.format, level, s, ...)))
    elseif level.value == Levels['info'].value then
      print(Utils.finalString(self.format, level, s, ...))
    elseif level.value == Levels['debug'].value then
      print(LuvUtils.colorize('green', Utils.finalString(self.format, level, s, ...)))
    elseif level.value == Levels['trace'].value then
      print(LuvUtils.colorize('cyan', Utils.finalString(self.format, level, s, ...)))
    end
  else 
    print(Utils.finalString(self.format, level, s, ...))
  end
end

return ConsoleLogger
