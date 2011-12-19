install: test
	@[ "$(DESTDIR)" = "" ] && (echo "ERROR: DESTDIR variable not set, unknown where to install to" 1>&2 && exit 1)
	@install -d "$(DESTDIR)"
	@install migrate "$(DESTDIR)"

test:
	@[ -d "tests" ] || (echo "ERROR: tests directory does not exist" && exit 1)
	@for t in tests/t*; do \
	  $$t; \
	done
	@echo "* All tests passed"
