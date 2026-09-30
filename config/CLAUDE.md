# Consignes globales de l'utilisateur, pour tout agent de code

## Règle d'écriture absolue : aucun tiret cadratin
Le tiret cadratin (caractère U+2014) est **totalement interdit**, sans aucune exception, ainsi que le demi-cadratin
(U+2013) et les entités HTML `&mdash;` / `&ndash;`. La règle vaut pour tout agent, quel que soit l'outil ou le modèle, et
pour tout ce qu'il écrit : réponses à l'utilisateur, documents, cours, fiches, pages web, libellés, courriels,
documentation, commentaires de code, messages de commit, descriptions de PR, consignes à d'autres agents.
- Ne pas le remplacer par un autre tiret (ni « - » entouré d'espaces, ni double tiret) : écrire une virgule, un
  deux-points, des parenthèses, un point, ou reformuler la phrase. Séparateur de titre : « · » ou « : ».
- Si du code a besoin du caractère (expression régulière, normalisation de texte), l'écrire sous forme d'échappement
  (`\u2014`), jamais en clair.
- Recopier cette règle dans toute consigne confiée à un sous-agent ou à un autre outil.
- Avant de rendre un travail, chercher le caractère dans ce qui a été écrit et le retirer.
- Un fichier existant qui en contient : les retirer dans les passages que l'on modifie, et le signaler à l'utilisateur.

## À chaque nouveau dépôt
Dès qu'un dépôt est créé ou initialisé (`git init`, nouveau projet, premier commit d'un dossier), y placer à la racine
un `AGENTS.md` qui contient la règle ci-dessus (gabarit : `~/.agents/templates/new-repo/AGENTS.md`), et un `CLAUDE.md`
d'une ligne, `@AGENTS.md`. Dans un dépôt existant qui n'a pas encore la règle, l'ajouter à son `AGENTS.md` à la première
occasion. Les consignes d'un dépôt s'écrivent toujours de façon neutre vis-à-vis de l'agent : `AGENTS.md`,
`.agents/skills/`, aucun outil ni modèle nommé.

Source commune à tous les agents : `~/.agents/AGENTS.md` (garder les deux fichiers identiques).
