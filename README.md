# claude-skills

Skills personnels, source unique pour le poste et pour les sessions cloud, quel que soit le dépôt ouvert.

| Skill | Rôle |
|-------|------|
| [`superviser`](skills/superviser/SKILL.md) | Mode superviseur : planifier, découper, déléguer à des sous-agents, vérifier. |

## Sessions cloud

Les sessions cloud tournent sur une machine isolée qui ne voit pas le `~/.claude/skills` du poste. Dans les réglages
de l'environnement cloud (claude.ai, Code, environnement, script de démarrage), ajouter :

```bash
git clone --depth 1 https://github.com/rgelrubin/claude-skills.git /tmp/claude-skills && bash /tmp/claude-skills/install.sh
```

L'accès réseau de l'environnement doit autoriser `github.com` (c'est le cas du niveau d'accès par défaut). Une
modification poussée sur `main` vaut pour toute session lancée ensuite.

## Poste Windows

Chaque skill est relié par une jonction, pour qu'une modification dans ce dépôt vaille aussitôt :

```powershell
New-Item -ItemType Junction -Path "$HOME\.claude\skills\superviser" -Target "C:\Dev\Source\Git\claude-skills\skills\superviser"
```

## Ajouter un skill

Créer `skills/<nom>/SKILL.md`, pousser sur `main`, puis sur le poste créer la jonction correspondante.
