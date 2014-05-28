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

### getLogger

```lua
local logger = Logger.getLogger(name)
```

### close

```lua
Logger.close()
```

### log

```lua
logger:log(level, message, ...)
```

### error

```lua
logger:error(message, ...)
```

### warn

```lua
logger:warn(message, ...)
```

### info

```lua
logger:info(message, ...)
```

### debug

```lua
logger:debug(message, ...)
```

### trace

```lua
logger:trace(message, ...)
```

### setLevel

```lua
logger:setLevel(level)
```

### getLevel

```lua
local level = logger:getLevel()
```

### getName

```lua
local name = logger:getName()
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

