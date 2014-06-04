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

test: test-init test-lua

test-init:
	mkdir -p test/modules
	ln -s ../../../luvit-logger/ test/modules/logger
	$(MAKE) -C ${CLOCKTIMEDIR} LUVIT=../../../${LUVIT}

test-lua:
	${LUVIT} test/console.lua
	${LUVIT} test/file.lua
	${LUVIT} test/levels.lua
	${LUVIT} test/root.lua
#	${LUVIT} test/redis.lua

clean:
	rm -fr test/modules
