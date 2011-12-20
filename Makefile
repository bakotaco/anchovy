install: test
	@[ "$(DESTDIR)" = "" ] && (echo "ERROR: DESTDIR variable not set, unknown where to install to" 1>&2 && exit 1)
	@install -d "$(DESTDIR)"
	@install migrate "$(DESTDIR)"


test:
	@[ -d "tests" ] || (echo "ERROR: tests directory does not exist" && exit 1)
	@cd tests; \
	for f in *; do \
	  if echo $$f | grep '^t[[:digit:]]\{4\}' >/dev/null; then \
	    echo "- $$f\t\c"; \
	    test_out=$$(. $(basename $$f) 2>&1); \
	    if [ $$? = 0 ]; then \
	      echo "[PASSED]"; \
	    else \
	      echo "[FAILURE]"; \
	      echo $$test_out; \
	    fi; \
	  fi \
	done
	@echo "* All tests passed"
