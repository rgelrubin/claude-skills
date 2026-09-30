#!/usr/bin/env bash
# Copie chaque dossier de skills/ dans ~/.claude/skills/, en remplaçant une version déjà présente.
# Prévu pour le script de démarrage des environnements cloud ; sur un poste, préférer un lien (voir README).
set -euo pipefail

source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skills"
target_dir="${HOME}/.claude/skills"
mkdir -p "$target_dir"

for skill in "$source_dir"/*/; do
  name="$(basename "$skill")"
  rm -rf "${target_dir:?}/${name}"
  cp -r "$skill" "${target_dir}/${name}"
  echo "skill installé : ${name}"
done
