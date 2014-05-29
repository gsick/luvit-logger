local Object   = require('core').Object
local Logger = require('logger')

local child = Object:extend()

local log = Logger.getLogger('console_logger')

log:trace("Cool")

function child:log()
  log:error("Should be logged from child")
  log:warn("Should be logged from child")
  log:info("Should be logged from child")
  log:debug("Should be logged from child")
  log:trace("Should be logged from child")
end

return child
