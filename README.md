# claude-skills

Configuration personnelle pour agents de code, installée à l'identique dans les sessions cloud, quel que soit le dépôt
ouvert.

| Élément | Source | Installé dans le cloud |
|---------|--------|------------------------|
| Skill [`superviser`](skills/superviser/SKILL.md) | ce dépôt | `~/.claude/skills/` |
| Skills `supabase`, `supabase-postgres-best-practices` | [supabase/agent-skills](https://github.com/supabase/agent-skills), cloné à chaque session | `~/.claude/skills/` |
| Consignes globales (règle sans tiret cadratin, nouveaux dépôts) | [`config/CLAUDE.md`](config/CLAUDE.md), [`config/agents/`](config/agents) | `~/.claude/CLAUDE.md`, `~/.agents/` |
| Style de sortie « Concise », plugin EODHD | [`config/settings.json`](config/settings.json) | fusionné dans `~/.claude/settings.json` |

## Sessions cloud

Les sessions cloud tournent sur une machine isolée qui ne voit pas la configuration du poste. Le script de
configuration de l'environnement cloud (claude.ai, Code, menu de l'environnement, engrenage) contient :

```bash
#!/bin/bash
rm -rf /tmp/claude-skills
git clone --depth 1 https://github.com/rgelrubin/claude-skills.git /tmp/claude-skills && bash /tmp/claude-skills/install.sh || echo "claude-skills : installation impossible"
```

En place dans l'environnement « Default » depuis le 2026-09-30 ; tout nouvel environnement doit recevoir le même
script. Le repli final évite qu'une indisponibilité de GitHub bloque le démarrage. Une modification poussée sur `main`
vaut pour toute session lancée ensuite.

Le skill EODHD lit sa clé dans la variable `EODHD_API_TOKEN` ; à défaut, il la demande. Pour ne pas la redonner à
chaque session, l'ajouter dans les identifiants d'API de l'environnement cloud, jamais dans ce dépôt.

## Poste Windows

`install.sh` ne fait rien hors Linux. Sur le poste :
- les skills de ce dépôt sont reliés par une jonction, pour qu'une modification vaille aussitôt :
  ```powershell
  New-Item -ItemType Junction -Path "$HOME\.claude\skills\superviser" -Target "C:\Dev\Source\Git\claude-skills\skills\superviser"
  ```
- les consignes globales restent sources sur le poste (`~/.claude/CLAUDE.md`, `~/.agents/`) : après les avoir modifiées,
  lancer `bash sync-from-local.sh`, puis committer et pousser.

## Ajouter un skill

Créer `skills/<nom>/SKILL.md`, pousser sur `main`, puis sur le poste créer la jonction correspondante.

## Ce qui n'a pas sa place ici

Dépôt public : aucun secret (jetons, clés d'API, identifiants de serveurs MCP), aucune information sur un employeur ou
un client, aucune mémoire de projet.
