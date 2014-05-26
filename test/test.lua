local os = require('os')

local Logger = require('logger')

--local opt = {'file': {'name': 'my_logger', 'path': '/tmp/toto.log', 'format': '%Y-%m-%dT%H:%M:%SZ%z', 'level': 'INFO'}}

--[[
{"name": "my_logger", "level": "error", "dateformat": "", "loggers": [
  {"type": "file", "path": "/tmp/toto.log", "dateformat": "", "level": "info"},
  {"type": "console", "color": false, "dateformat": "", "level": "info"},
  {"type": "redis", "url": "/tmp/toto.log", "cmd":"publish toto %s", "rpush toto %s", "level": "info", "date": false},
  {"type": "syslog", "host": "", "port": "", "facility": "", "level": "info"}
]}
]]

local utils = require('utils')
print(utils.dump(true))

local opt = {name = 'my_logger', type = 'file', path = '/tmp/toto.log', level = 'info'}
opt.format = '%Y-%m-%dT%H:%M:%SZ%z'

local logger = Logger:new('conf.json')
local log = Logger.getLogger('my_logger')

--local log = Logger.getLogger(opt, "conf.json")

log:error("Should be logged")
log:warn("Should be logged")
log:info("Should be logged")
log:debug("Should not be logged")
log:trace("Should not be logged")

log:setLevel(Logger.ERROR)
assert(Logger.ERROR == log:getLevel())

log:error("Should be logged")
log:warn("Should not be logged")
log:info("Should not be logged")
log:debug("Should not be logged")
log:trace("Should not be logged")

log:setLevel(Logger.WARN)
assert(Logger.WARN == log:getLevel())

log:error("Should be logged")
log:warn("Should be logged")
log:info("Should not be logged")
log:debug("Should not be logged")
log:trace("Should not be logged")

log:setLevel(Logger.INFO)
assert(Logger.INFO == log:getLevel())

log:error("Should be logged")
log:warn("Should be logged")
log:info("Should be logged")
log:debug("Should not be logged")
log:trace("Should not be logged")

log:setLevel(Logger.DEBUG)
assert(Logger.DEBUG == log:getLevel())

log:error("Should be logged")
log:warn("Should be logged")
log:info("Should be logged")
log:debug("Should be logged")
log:trace("Should not be logged")

log:setLevel(Logger.TRACE)
assert(Logger.TRACE == log:getLevel())

log:error("Should be logged")
log:warn("Should be logged")
log:info("Should be logged")
log:debug("Should be logged")
log:trace("Should be logged")

log:setLevel('level')
assert(Logger.TRACE == log:getLevel())

log:error("Should be logged")
log:warn("Should be logged")
log:info("Should be logged")
log:debug("Should be logged")
log:trace("Should be logged")

log:log(Logger.ERROR, 'Should be ERROR')
log:log(Logger.WARN, 'Should be WARN')
log:log(Logger.INFO, 'Should be INFO')
log:log(Logger.DEBUG, 'Should be DEBUG')
log:log(Logger.TRACE, 'Should be TRACE')

log:log(Logger.INFO, 'Should be %s quoted %q %c %X', 'formatted', 'yes', 76, 1024)
