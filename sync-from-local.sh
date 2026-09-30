#!/usr/bin/env bash
# Sur le poste : recopie dans config/ les consignes globales locales, qui restent la source, avant commit.
set -euo pipefail
repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "${HOME}/.claude/CLAUDE.md" "${repo_dir}/config/CLAUDE.md"
cp "${HOME}/.agents/AGENTS.md" "${repo_dir}/config/agents/AGENTS.md"
cp "${HOME}/.agents/templates/new-repo/"* "${repo_dir}/config/agents/templates/new-repo/"
git -C "$repo_dir" status --short config
