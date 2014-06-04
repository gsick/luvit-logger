LUVIT  = luvit
CFLAGS = $(shell $(LUVIT) --cflags | sed s/-Werror//)
LIBS   = $(shell $(LUVIT) --libs)

CLOCKTIMEDIR=test/modules/clocktime
REDISDIR=test/modules/redis

${CLOCKTIMEDIR}/Makefile:
	git submodule update --init ${CLOCKTIMEDIR}
	$(MAKE) -C ${CLOCKTIMEDIR}

${REDISDIR}/Makefile:
	git submodule update --init ${REDISDIR}

test: test-init ${CLOCKTIMEDIR}/Makefile ${REDISDIR}/Makefile test-lua

test-init:
	mkdir -p test/modules
	ln -s ../../../luvit-logger/ test/modules/logger

test-lua:
	cd test
	${LUVIT} console.lua
	${LUVIT} file.lua
	${LUVIT} levels.lua
	${LUVIT} root.lua
#	${LUVIT} redis.lua

clean:
	rm -fr test/modules
