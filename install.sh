#!/usr/bin/env bash
# Installe la configuration personnelle dans une session cloud : skills, consignes globales, réglages, plugins.
# Prévu pour le script de configuration des environnements cloud (Linux). Sur le poste, ne pas le lancer : voir README.
# Chaque étape est indépendante ; un échec est signalé sans interrompre les suivantes.
set -uo pipefail

if [[ "$(uname -s)" != "Linux" && -z "${CLAUDE_SKILLS_FORCE:-}" ]]; then
  echo "install.sh est prévu pour les sessions cloud (Linux) ; rien n'est fait."
  exit 0
fi

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
claude_dir="${HOME}/.claude"
mkdir -p "${claude_dir}/skills" "${HOME}/.agents"

copy_skills() { # $1 : dossier contenant un sous-dossier par skill
  for skill in "$1"/*/; do
    [[ -f "${skill}SKILL.md" ]] || continue
    name="$(basename "$skill")"
    rm -rf "${claude_dir:?}/skills/${name}"
    cp -r "$skill" "${claude_dir}/skills/${name}"
    echo "skill installé : ${name}"
  done
}

# 1. Skills de ce dépôt.
copy_skills "${repo_dir}/skills"

# 2. Skills Supabase, pris à leur source.
supabase_tmp="$(mktemp -d)"
if git clone -q --depth 1 https://github.com/supabase/agent-skills.git "$supabase_tmp"; then
  copy_skills "${supabase_tmp}/skills"
else
  echo "skills Supabase : clonage impossible"
fi
rm -rf "$supabase_tmp"

# 3. Consignes globales et dossier commun des agents.
if [[ ! -f "${claude_dir}/CLAUDE.md" ]]; then
  cp "${repo_dir}/config/CLAUDE.md" "${claude_dir}/CLAUDE.md"
elif ! grep -q "Règle d'écriture absolue" "${claude_dir}/CLAUDE.md"; then
  printf '\n' >> "${claude_dir}/CLAUDE.md"
  cat "${repo_dir}/config/CLAUDE.md" >> "${claude_dir}/CLAUDE.md"
fi
cp -r "${repo_dir}/config/agents/." "${HOME}/.agents/"
echo "consignes globales installées"

# 4. Réglages : fusion dans ~/.claude/settings.json, sans écraser ce qui s'y trouve déjà.
merge_settings='
const fs = require("fs");
const [target, source] = process.argv.slice(1);
const isObj = (v) => v && typeof v === "object" && !Array.isArray(v);
const merge = (a, b) => {
  for (const [k, v] of Object.entries(b)) a[k] = isObj(v) && isObj(a[k]) ? merge(a[k], v) : v;
  return a;
};
const current = fs.existsSync(target) ? JSON.parse(fs.readFileSync(target, "utf8")) : {};
fs.writeFileSync(target, JSON.stringify(merge(current, JSON.parse(fs.readFileSync(source, "utf8"))), null, 2) + "\n");
'
if command -v node >/dev/null && node -e "$merge_settings" "${claude_dir}/settings.json" "${repo_dir}/config/settings.json"; then
  echo "réglages fusionnés"
else
  echo "réglages : fusion impossible (node absent ou fichier illisible)"
fi

# 5. Plugin EODHD, si la commande claude est déjà présente (sinon les réglages le déclarent au démarrage).
if command -v claude >/dev/null; then
  { claude plugin marketplace add https://github.com/EodHistoricalData/eodhd-claude-skills.git \
      && claude plugin install eodhd-api@eodhd-claude-skills; } >/dev/null 2>&1 \
    && echo "plugin EODHD installé" || echo "plugin EODHD : installation par la commande impossible"
else
  echo "plugin EODHD : commande claude absente, déclaré dans les réglages"
fi
