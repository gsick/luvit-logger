#!/usr/bin/env luvit

local Fs     = require('fs')
local String = require('string')
local Logger = require('logger')

-- parent level info
-- log1 level error
-- log2 level debug
-- log3 inherit

if Fs.existsSync('/tmp/test/log1.log') then
  Fs.truncateSync('/tmp/test/log1.log')
end
if Fs.existsSync('/tmp/test/log2.log') then
  Fs.truncateSync('/tmp/test/log2.log')
end
if Fs.existsSync('/tmp/test/log3.log') then
  Fs.truncateSync('/tmp/test/log3.log')
end

local function assertLine(logname)
  local data = Fs.readFileSync('/tmp/test/' .. logname .. '.log')
  String.gsub(data, '(.-)\r?\n', function(s)
    if not String.find(s, logname) then
      error( logname .. ' not found in ' .. logname .. '.log')
    end
  end)
end

local logger = Logger:new('file.json')
local log = Logger.getLogger('file_logger')

log:error("Should be logged in log1 log2 log3")
log:warn("Should be logged in log2 log3")
log:info("Should be logged in log2 log3")
log:debug("Should be logged in log2")
log:trace("Should be logged")

log:setLevel(Logger.ERROR)
assert(Logger.ERROR == log:getLevel())

log:error("Should be logged in log1 log2 log3")
log:warn("Should be logged in log2")
log:info("Should be logged in log2")
log:debug("Should be logged in log2")
log:trace("Should be logged")

log:setLevel(Logger.WARN)
assert(Logger.WARN == log:getLevel())

log:error("Should be logged in log1 log2 log3")
log:warn("Should be logged in log2 log3")
log:info("Should be logged in log2")
log:debug("Should be logged in log2")
log:trace("Should be logged")

log:setLevel(Logger.INFO)
assert(Logger.INFO == log:getLevel())

log:error("Should be logged in log1 log2 log3")
log:warn("Should be logged in log2 log3")
log:info("Should be logged in log2 log3")
log:debug("Should be logged in log2")
log:trace("Should be logged")

log:setLevel(Logger.DEBUG)
assert(Logger.DEBUG == log:getLevel())

log:error("Should be logged in log1 log2 log3")
log:warn("Should be logged in log2 log3")
log:info("Should be logged in log2 log3")
log:debug("Should be logged in log2 log3")
log:trace("Should be logged")

log:setLevel(Logger.TRACE)
assert(Logger.TRACE == log:getLevel())

log:error("Should be logged in log1 log2 log3")
log:warn("Should be logged in log2 log3")
log:info("Should be logged in log2 log3")
log:debug("Should be logged in log2 log3")
log:trace("Should be logged in log3")

log:setLevel('level')
assert(Logger.TRACE == log:getLevel())

log:error("Should be logged in log1 log2 log3")
log:warn("Should be logged in log2 log3")
log:info("Should be logged in log2 log3")
log:debug("Should be logged in log2 log3")
log:trace("Should be logged in log3")

assertLine('log1')
assertLine('log2')
assertLine('log3')

process:on('exit', function()
  Logger.close()
end)
