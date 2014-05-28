#!/usr/bin/env luvit

local Fs     = require('fs')
local Redis  = require('redis')
local String = require('string')
local Logger = require('logger')

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

local client = Redis:new("127.0.0.1", 6379)

client:command('DEL', 'log', function()

  local logger = Logger:new('redis.json')
  local log = Logger.getLogger('redis_logger')

  log:log(Logger.ERROR, 'Should be ERROR')
  log:log(Logger.WARN, 'Should be WARN')
  log:log(Logger.INFO, 'Should be INFO')
  log:log(Logger.DEBUG, 'Should be DEBUG')
  log:log(Logger.TRACE, 'Should be TRACE')
end)

local Timer = require('timer')
Timer.setTimeout(500, function()
  Logger.close()

  client:command('LLEN', 'log', function(err, res)
    assert(res == 3)
  end)
  client:command('LPOP', 'log', function(err, res)
    if not String.find(res, 'ERROR') then
      error('ERROR not found in redis')
    end
  end)
  client:command('LPOP', 'log', function(err, res)
    if not String.find(res, 'WARN') then
      error('WARN not found in redis')
    end
  end)
  client:command('LPOP', 'log', function(err, res)
    if not String.find(res, 'INFO') then
      error('INFO not found in redis')
    end
  end)
  client:command('LPOP', 'log', function(err, res)
    if res then
      error('Get something in redis')
    end
  end)
  client:command('LPOP', 'log', function(err, res)
    if res then
      error('Get something in redis')
    end
    client:disconnect()
  end)
  
  assertLine('log-redis')
end)

