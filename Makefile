.PHONY: help check hooks scan sanitize report test

FILE ?= README.md

help:
	@echo "Available targets:"
	@echo "  make help        - show this help"
	@echo "  make check       - run full local checks"
	@echo "  make hooks       - install pre-commit hook"
	@echo "  make scan        - scan a file (default: README.md)"
	@echo "  make sanitize    - sanitize neofetch output"
	@echo "  make report      - generate sanitized report"
	@echo "  make test        - run fixture-based tests"

check:
	./tools/run-checks.sh

hooks:
	./tools/install-hooks.sh

scan:
	./tools/redflag-scan.sh $(FILE) || true

sanitize:
	neofetch | ./tools/sanitize-neofetch.sh --strict

report:
	./tools/make-sanitized-report.sh

test:
	@echo "[test] checking sensitive metadata fixture"
	@./tools/redflag-scan.sh --fail examples/fixtures/sample-sensitive.txt >/dev/null 2>&1 || test $$? -eq 2
	@echo "[test] checking secrets fixture"
	@./tools/redflag-scan.sh --fail examples/fixtures/sample-secrets.txt >/dev/null 2>&1 || test $$? -eq 2
	@echo "[test] checking clean fixture"
	@./tools/redflag-scan.sh --fail examples/fixtures/sample-clean.txt >/dev/null
	@echo "[ok] fixture-based tests passed"
