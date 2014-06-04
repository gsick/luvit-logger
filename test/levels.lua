#!/usr/bin/env luvit

local PathJoin = require('path').join
local Fs     = require('fs')
local String = require('string')
local Logger = require('logger')

if Fs.existsSync('/tmp/test/log-level.log') then
  Fs.truncateSync('/tmp/test/log-level.log')
end

local function assertLine(logname)
  local data = Fs.readFileSync('/tmp/test/' .. logname .. '.log')
  --print(data)

  local i = 0
  String.gsub(data, '(.-)\r?\n', function(s)
    i = i + 1
    
    if i == 1 then
      if not String.find(s, 'ERROR') then
        error('ERROR not found in ' .. logname .. '.log')
      end
    elseif i == 2 then
      if not String.find(s, 'WARN') then
        error('WARN not found in ' .. logname .. '.log')
      end
    elseif i == 3 then
      if not String.find(s, 'INFO') then
        error('INFO not found in ' .. logname .. '.log')
      end
    elseif i == 4 then
      if not String.find(s, 'DEBUG') then
        error('DEBUG not found in ' .. logname .. '.log')
      end
    elseif i == 5 then
      if not String.find(s, 'TRACE') then
        error('TRACE not found in ' .. logname .. '.log')
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
