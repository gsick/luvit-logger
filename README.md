[![Build Status](https://travis-ci.org/gsick/luvit-logger.svg?branch=0.0.1)](https://travis-ci.org/gsick/luvit-logger)

luvit-logger
============

Simple Logger for Luvit.<br />
Log in console, file, Redis.

## Table of Contents

* [Status](#status)
* [Usage](#usage)
* [Configuration](#configuration)
    * [Basic](#basic)
    * [Advanced](#advanced)
* [API](#api)
    * [new](#new)
    * [getLogger](#getlogger)
    * [close](#close)
    * [log](#log)
    * [error](#error)
    * [warn](#warn)
    * [info](#info)
    * [debug](#debug)
    * [trace](#trace)
    * [setLevel](#setlevel)
    * [getLevel](#getlevel)
    * [getName](#getname)
* [Logrotate example](#logrotate-example)
* [Installation](#installation)
* [Tests](#tests)
* [Authors](#authors)
* [Contributing](#contributing)
* [Licence](#licence)

## Status

0.0.1 released

## Usage

```lua
local Logger = require('logger')

Logger:new('conf.json')
local logger = Logger.getLogger('my_logger')

logger:error('log some error')
logger:warn('log some warning')
logger:info('log some info')
logger:debug('log some debug info')
logger:trace('log some trace info')

logger:log(Logger.ERROR, 'log error')
logger:log(Logger.WARN, 'log warn')
logger:log(Logger.INFO, 'log info')
logger:log(Logger.DEBUG, 'log debug')
logger:log(Logger.TRACE, 'log trace')

logger:log(Logger.INFO, 'log %s', 'info')

process:on('exit', function()
  Logger.close()
end)
```

```shell
[2014-05-29][09:00:49.517][ERROR] log some error
[2014-05-29][09:00:49.517][WARN ] log some warning
[2014-05-29][09:00:49.517][INFO ] log some info
[2014-05-29][09:00:49.517][DEBUG] log some debug info
[2014-05-29][09:00:49.517][TRACE] log some trace info
[2014-05-29][09:00:49.517][ERROR] log error
[2014-05-29][09:00:49.517][WARN ] log warn
[2014-05-29][09:00:49.520][INFO ] log info
[2014-05-29][09:00:49.520][DEBUG] log debug
[2014-05-29][09:00:49.520][TRACE] log trace
[2014-05-29][09:00:49.520][INFO ] log info
```

In other luvit file:

```lua
local Logger = require('logger')

local logger = Logger.getLogger('my_logger')
logger:log('log something')
```

## Configuration

### Basic

```json
[
  {
    "name": "my_logger",
    "level": "info",
    "loggers": [
      {
        "type": "file",
        "path": "/var/log/project.log"
      },
      {
        "type": "console",
        "color": false
      }
    ]
  }
]
```

### Advanced

```json
[
  {
    "name": "file_logger",
    "level": "info",
    "dateformat": "%H:%M:%S",
    "loggers": [
      {
        "type": "file",
        "path": "/var/log/project-error.log",
        "level": "error"
      },
      {
        "type": "file",
        "path": "/var/log/project.log",
        "level": "trace",
        "dateformat": "%Y-%m-%dT%H:%M:%SZ%z"
      }
    ]
  },
  {
    "name": "console_logger",
    "level": "trace",
    "loggers": [
      {
        "type": "console",
        "color": true
      }
    ]
  },
  {
    "name": "redis_logger",
    "level": "trace",
    "loggers": [
      {
        "type": "redis",
        "port": 6379,
        "host": "127.0.0.1",
        "cmd":"rpush",
        "key": "log",
        "level": "info",
        "date": false,
        "reconnect": true
      },
      {
        "type": "redis",
        "port": 6379,
        "host": "127.0.0.1",
        "cmd":"publish",
        "key": "log_channel",
        "level": "info",
        "reconnect": true
      },
      {
        "type": "file",
        "path": "/var/log/project-redis.log"
      }
    ]
  }
]
```

## API

### new

```lua
Logger:new(filename)
```

Instanciate a new configuration.

* `filename`: LUA_TSTRING, path to the configuration json file

### getLogger

```lua
local logger = Logger.getLogger(name)
```

Return a logger.

* `name`: LUA_TSTRING, name of the logger

### close

```lua
Logger.close()
```

Close in a clean way (close file, disconnect redis).

### log

```lua
logger:log(level, message, ...)
```

Log a message.

* `level`: `Logger.ERROR`, `Logger.WARN`, `Logger.INFO`, `Logger.DEBUG`, `Logger.TRACE`
* `message`: LUA_TSTRING, could be a formatted string

### error

```lua
logger:error(message, ...)
```

Log a message with ERROR level.

* `message`: LUA_TSTRING, could be a formatted string

### warn

```lua
logger:warn(message, ...)
```

Log a message with WARN level.

* `message`: LUA_TSTRING, could be a formatted string

### info

```lua
logger:info(message, ...)
```

Log a message with INFO level.

* `message`: LUA_TSTRING, could be a formatted string

### debug

```lua
logger:debug(message, ...)
```

Log a message with DEBUG level.

* `message`: LUA_TSTRING, could be a formatted string

### trace

```lua
logger:trace(message, ...)
```

Log a message with TRACE level.

* `message`: LUA_TSTRING, could be a formatted string

### setLevel

```lua
logger:setLevel(level)
```

Change the level of the root.

* `level`: `Logger.ERROR`, `Logger.WARN`, `Logger.INFO`, `Logger.DEBUG`, `Logger.TRACE`

### getLevel

```lua
local level = logger:getLevel()
```

Get the level of the root.

Return one of these: `Logger.ERROR`, `Logger.WARN`, `Logger.INFO`, `Logger.DEBUG`, `Logger.TRACE`

### getName

```lua
local name = logger:getName()
```

Return the name of the logger.

## Logrotate example

Example /etc/logrotate.d/project.conf

```text
/var/log/project/project.log {
  daily
  rotate 30
  size 200k
  create 640 root
  compress
  delaycompress
  copytruncate
  notifempty
  missingok
  olddir /somewhere/../logs
}
```

Maybe you may want to move logrotate script from /etc/cron.daily to /etc/cron.hourly

Test:
```bash
$ logrotate -d /etc/logrotate.d/project.conf
$ logrotate -f /etc/logrotate.d/project.conf
```

## Installation

Add dependency in your package.lua file

## Tests

## Authors

Gamaliel Sick

## Contributing

  * Fork it
  * Create your feature branch (git checkout -b my-new-feature)
  * Commit your changes (git commit -am 'Add some feature')
  * Push to the branch (git push origin my-new-feature)
  * Create new Pull Request

## License

```
The MIT License (MIT)

Copyright (c) 2014 gsick

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

