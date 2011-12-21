install: test
	@[ "$(DESTDIR)" = "" ] && (echo "ERROR: DESTDIR variable not set, unknown where to install to" 1>&2 && exit 1)
	@install -d "$(DESTDIR)"
	@install migrate "$(DESTDIR)"


test:
	@[ -d "tests" ] || (echo "ERROR: tests directory does not exist" && exit 1)
	@cd tests; \
	failed=0; \
	passed=0; \
	for f in *; do \
	  if echo $$f | grep '^t[[:digit:]]\{4\}' >/dev/null; then \
	    echo "- $$f\t\c"; \
	    test_out=$$(. $(basename $$f) 2>&1); \
	    if [ $$? = 0 ]; then \
	      echo "[PASSED]"; \
	      passed=$$(($$passed+1)); \
	    else \
	      echo "[FAILURE]"; \
	      echo "$$test_out"; \
	      failed=$$(($$failed+1)); \
	    fi; \
	  fi \
	done; \
	stats="(passed: $$passed, failed: $$failed)"; \
	if [ $$failed = 0 ]; then \
	  echo "* All tests passed $$stats"; \
	else \
	  echo "* TESTS FAILED $$stats"; \
	  false; \
	fi
