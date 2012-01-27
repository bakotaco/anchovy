install: check_destdir test
	@install -d "$(DESTDIR)/bin"
	@install migrate "$(DESTDIR)/bin"
	@echo "OK: installed migrate into $(DESTDIR)"

check_destdir:
	@if [ "$(DESTDIR)" = "" ]; then \
	  echo "ERROR: DESTDIR variable not set, unknown where to install to" 1>&2; \
	  exit 1; \
	fi

test:
	@[ -d "tests" ] || (echo "ERROR: tests directory does not exist" && exit 1)
	@cd tests; \
	failed=0; \
	passed=0; \
	for f in *; do \
	  if echo $$f | grep '^t[[:digit:]]\{4\}' >/dev/null; then \
	    test_out=$$(. $(basename $$f) 2>&1); \
	    exit_status=$$?; \
	    if [ $$exit_status = 0 ]; then \
	      printf "%-50s %s\n" $$f "[OK]"; \
	      passed=$$(($$passed+1)); \
	    elif [ $$exit_status = 255 ]; then \
	      echo "ERROR: Prerequisites to run tests not met"; \
	      echo "$$test_out"; \
	      exit 1; \
	    else \
	      printf "%-50s %s\n" $$f "[FAILURE]"; \
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
