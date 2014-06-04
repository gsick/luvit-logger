LUVIT  = luvit
CFLAGS = $(shell $(LUVIT) --cflags | sed s/-Werror//)
LIBS   = $(shell $(LUVIT) --libs)

CLOCKTIMEDIR=test/modules/clocktime
REDISDIR=test/modules/redis

test: test-lua

test-lua:
	mkdir -p test/modules
	git submodule update --init ${REDISDIR}
	git submodule update --init ${CRYPTODIR}
	ln -s ../../../luvit-logger/ test/modules/logger
	${LUVIT} test/console.lua

clean:
	rm -fr test/modules
