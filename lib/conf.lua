local Json    = require('json')
local Fs      = require('fs')
local Object  = require('core').Object
local Watcher = require('uv').Watcher

local Conf = Object:extend()

function Conf:initialize(path)
  if Fs.existsSync(path) then
    self.path = path
  else
    error('No configuration file found')
  end
end

function Conf:read()
  if not self.path then
    return nil
  end
  local content = Fs.readFileSync(self.path)
  local json = Json.parse(content)
  return json
end

function Conf:watch(callback)
  if not self.path then
    return nil
  end
  
  --local watcher = Watcher:new(self.path)
  --watcher:on('change', callback)
end

return Conf
