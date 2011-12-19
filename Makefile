test:
	@[ -d "tests" ] || (echo "ERROR: tests directory does not exist" && exit 1)
	@for t in tests/t*; do \
	  $$t; \
	done
