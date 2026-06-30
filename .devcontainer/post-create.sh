#!/usr/bin/env bash
# Provision docs tooling that isn't a devcontainer "feature".
set -euo pipefail

echo ">> Installing lychee (link checker)"
if ! command -v lychee >/dev/null 2>&1; then
  curl -fsSL https://github.com/lycheeverse/lychee/releases/latest/download/lychee-x86_64-unknown-linux-gnu.tar.gz \
    | tar -xz -C /usr/local/bin lychee || echo "   (lychee install skipped; install manually if needed)"
fi

echo ">> Installing Vale (prose linter)"
if ! command -v vale >/dev/null 2>&1; then
  curl -fsSL https://github.com/errata-ai/vale/releases/latest/download/vale_Linux_64-bit.tar.gz \
    | tar -xz -C /usr/local/bin vale || echo "   (vale install skipped; install manually if needed)"
fi

echo ">> Installing pre-commit"
pipx install pre-commit >/dev/null 2>&1 || pip install --user pre-commit >/dev/null 2>&1 || true
command -v pre-commit >/dev/null 2>&1 && pre-commit install || true

echo ">> Syncing Vale styles"
command -v vale >/dev/null 2>&1 && vale sync || true

echo ">> Dev container ready. Run 'make test' to lint the docs."
