#!/usr/bin/env bash

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

for f in "$REPO_ROOT"/.agents/rules/*.md; do
    [ -e "$f" ] || continue
    base=$(basename "$f" .md)
    ln -sfn "../../.agents/rules/${base}.md" "$REPO_ROOT/.cursor/rules/${base}.mdc"
done