local Object = require('core').Object
local String = require('string')
local Fs     = require('fs')
local Path   = require('path')
local Levels = require('./utils').Levels
local Utils  = require('./utils')

local function _noop(err)
  if err then
    error('Logger error: ' .. err.message)
  end
end

local FileLogger = Object:extend()

function FileLogger:initialize(options)

  self.type = options.type

  self.level = nil
  if type(options.level) == 'string' and Levels[String.lower(options.level)] then
    self.level = Levels[String.lower(options.level)]
  end

  self.dateformat = nil
  if options.dateformat and type(options.dateformat) == 'string' then
    self.dateformat = options.dateformat
  end

  if type(options.path) ~= 'string' then
    error('path: ' .. Utils.dump(options.path) .. ' is not a string')
  end
  self.path = options.path

  local dirname = Path.dirname(self.path)
  if not Fs.existsSync(dirname) then
    Fs.mkdir(dirname, '0740')
  end
  self.fd = Fs.openSync(self.path, 'a+', '0640')

end

function FileLogger:log(parent_level, level, s, ...)

  local final_level = self.level or parent_level

  if level.value <= final_level.value then
    Fs.write(self.fd, 0, Utils.finalString(self.dateformat, level, s, ...) .. '\n', _noop)
  end
end

function FileLogger:close()
  Fs.closeSync(self.fd)
end

return FileLogger
