.PHONY: help check hooks scan sanitize report repo-report

help:
	@echo "Available targets:"
	@echo "  make help      - show this help message"
	@echo "  make check     - run local defensive checks"
	@echo "  make hooks     - install portable pre-commit hook"
	@echo "  make scan      - scan repository files for red flags"
	@echo "  make sanitize  - sanitize neofetch output"
	@echo "  make report    - generate a sanitized report"

check:
	./tools/run-checks.sh

hooks:
	./tools/install-hooks.sh

scan:
	./tools/redflag-scan.sh README.md || true

sanitize:
	neofetch | ./tools/sanitize-neofetch.sh --strict

report:
	./tools/make-sanitized-report.sh

repo-report:
	./tools/repo-report.sh
