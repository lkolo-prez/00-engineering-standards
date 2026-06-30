# Makefile for the engineering-standards (docs) repo.
# This repo has no compiled artifact; "build" lints the docs.
# Targets mirror the org-standard contract: setup lint format test build run security sbom clean.

SHELL := bash
.DEFAULT_GOAL := help

MD_GLOBS := "**/*.md"
PROSE_PATHS := docs README.md CATALOG.md CONTRIBUTING.md

.PHONY: help
help: ## Show this help.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

.PHONY: setup
setup: ## Install dev tooling (markdownlint, lychee, vale) + pre-commit hooks.
	@echo ">> Installing docs tooling"
	npm install --no-save markdownlint-cli2
	@command -v lychee >/dev/null 2>&1 || echo "   (install lychee: https://github.com/lycheeverse/lychee)"
	@command -v vale   >/dev/null 2>&1 || echo "   (install vale:   https://vale.sh/docs/vale-cli/installation/)"
	@command -v pre-commit >/dev/null 2>&1 && pre-commit install || echo "   (install pre-commit: https://pre-commit.com)"

.PHONY: lint
lint: ## Lint Markdown (markdownlint) + prose (vale).
	npx markdownlint-cli2 $(MD_GLOBS)
	@command -v vale >/dev/null 2>&1 && vale $(PROSE_PATHS) || echo "   (vale not installed; skipping prose lint)"

.PHONY: format
format: ## Auto-fix Markdown issues.
	npx markdownlint-cli2 --fix $(MD_GLOBS)

.PHONY: linkcheck
linkcheck: ## Check links with lychee.
	@command -v lychee >/dev/null 2>&1 \
		&& lychee --no-progress --exclude 'aircloud\.example' --exclude 'example\.com' $(MD_GLOBS) \
		|| echo "   (lychee not installed; skipping link check)"

.PHONY: test
test: lint linkcheck ## Run all checks (lint + link check). Alias used by CI/AI assistants.

.PHONY: build
build: test ## "Build" the docs == all checks pass. No artifact is produced.
	@echo ">> Docs build OK (lint + linkcheck passed)"

.PHONY: run
run: ## Serve the docs locally for preview (simple static server).
	@echo ">> Open the Markdown in your editor's preview, or run a static server:"
	python3 -m http.server 8080

.PHONY: security
security: ## Run secret scan (gitleaks) over the repo.
	@command -v gitleaks >/dev/null 2>&1 \
		&& gitleaks detect --no-banner --redact \
		|| echo "   (gitleaks not installed: https://github.com/gitleaks/gitleaks)"

.PHONY: sbom
sbom: ## No shippable artifact in a docs repo; emit a minimal CycloneDX SBOM of dev tooling.
	@command -v syft >/dev/null 2>&1 \
		&& syft dir:. -o cyclonedx-json=sbom.cdx.json && echo ">> wrote sbom.cdx.json" \
		|| echo "   (no buildable artifact; install syft to SBOM dev tooling if desired)"

.PHONY: clean
clean: ## Remove caches and generated files.
	rm -rf node_modules .lycheecache .cache sbom.cdx.json results.sarif
