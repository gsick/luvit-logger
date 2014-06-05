#!/usr/bin/env luvit

local PathJoin = require('path').join
local Fs     = require('fs')
local String = require('string')
local Logger = require('logger')

if Fs.existsSync(PathJoin(__dirname, 'tmp/log-level.log')) then
  Fs.truncateSync(PathJoin(__dirname, 'tmp/log-level.log'))
end

local function assertLine(logname)
  local data = Fs.readFileSync(PathJoin(__dirname, 'tmp/' .. logname .. '.log'))
  --print(data)

  local error = false
  local warn = false
  local info = false
  local debug = false
  local trace = false
  local i = 0
  String.gsub(data, '(.-)\r?\n', function(s)
    i = i + 1

    if String.find(s, 'ERROR') then
      error = true
    end
    if String.find(s, 'WARN') then
      warn = true
    end
    if String.find(s, 'INFO') then
      info = true
    end
    if String.find(s, 'DEBUG') then
      debug = true
    end
    if String.find(s, 'TRACE') then
      trace = true
    end
    if i > 5 then
      error('too much line found in ' .. logname .. '.log')
    end
    if i == 5 then
      if not (error and warn and info and debug and trace) then
        error('one level missing in ' .. logname .. '.log')
      end
    end
  end)
end

Logger:new(PathJoin(__dirname, 'file.json'))
local log = Logger.getLogger('level_logger')

log:log(Logger.ERROR, 'Should be ERROR')
log:log(Logger.WARN, 'Should be WARN')
log:log(Logger.INFO, 'Should be INFO')
log:log(Logger.DEBUG, 'Should be DEBUG')
log:log(Logger.TRACE, 'Should be TRACE')

-- because async write
local Timer = require('timer')
Timer.setTimeout(100, function()
  assertLine('log-level')
end)

--log:log(Logger.INFO, 'Should be %s quoted %q %c %X', 'formatted', 'yes', 76, 1024)
process:on('exit', function()
  Logger.close()
end)
