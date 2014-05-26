local Object = require('core').Object
local String = require('string')
local Fs     = require('fs')
local Levels = require('./utils').Levels
local Utils  = require('./utils')

local function _noop() end

local FileLogger = Object:extend()

function FileLogger:initialize(options)

  self.type = options.type

  self.level = nil
  if type(options.level) == 'string' and Levels[String.lower(options.level)] then
    self.level = Levels[String.lower(options.level)]
  end

  self.format = nil
  if options.format and type(options.format) == 'string' then
    self.format = options.format
  end

  if type(options.path) ~= 'string' then
    error("path: " .. Utils.dump(options.path) .. ' is not a string')
  end
  self.path = options.path
  
  self.fd = Fs.openSync(options.path, "a+")

end

function FileLogger:log(parent_level, level, s, ...)

  local final_level = self.level or parent_level

  if level.value > final_level.value then
    return
  end
  
  Fs.write(self.fd, 0, Utils.finalString(self.format, level, s, ...) .. '\n', _noop)
end

return FileLogger
