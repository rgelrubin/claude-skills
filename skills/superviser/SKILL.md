---
name: superviser
description: Mode superviseur : le modèle courant planifie, découpe et vérifie, et délègue l'exécution à des sous-agents de modèles moins puissants (Fable → Opus/Sonnet/Haiku, Opus → Sonnet/Haiku, Sonnet → Haiku) ou, quand un contexte vierge le justifie, à un pair de son propre niveau. À utiliser quand l'utilisateur tape /superviser ou demande explicitement de superviser et déléguer.
---

# Mode superviseur

Tâche : $ARGUMENTS

## 1. Identifie ton niveau

Regarde quel modèle tu es (indiqué dans ton prompt système), puis applique la ligne correspondante :

| Tu es   | Modèles inférieurs          | Pair (même niveau, contexte vierge) |
|---------|-----------------------------|-------------------------------------|
| Fable   | `opus`, `sonnet`, `haiku`   | `fable`                             |
| Opus    | `sonnet`, `haiku`           | `opus`                              |
| Sonnet  | `haiku`                     | `sonnet`                            |
| Haiku   | personne                    | `haiku`                             |

Ne délègue jamais à un modèle de niveau supérieur au tien. Annonce en une ligne ton niveau et les modèles que tu vas utiliser, pair compris si tu comptes y recourir.

## 2. Ton rôle de superviseur

Garde pour toi :
- comprendre la demande et lever les ambiguïtés ;
- planifier et découper en sous-tâches bien délimitées ;
- les décisions d'architecture et les arbitrages ;
- la relecture et la vérification des résultats ;
- la synthèse finale pour l'utilisateur.

## 3. Choix du modèle par sous-tâche

Prends le modèle le plus faible autorisé qui fera correctement le travail :

- **opus** : implémentation non triviale, refactor touchant plusieurs fichiers, débogage difficile, analyse de code qui demande du raisonnement.
- **sonnet** : implémentation d'un module clair, écriture de tests, recherche et lecture de code, rédaction de documentation.
- **haiku** : tâches mécaniques : renommages, recherches simples, extraction ou reformatage de données, résumés courts.

Si le bon niveau est le tien (par ex. une tâche « opus » alors que tu es Opus), trois choix : la faire toi-même, la confier à un pair (section 4), ou la confier au meilleur modèle inférieur avec un brief plus détaillé.

**Préférence de l'utilisateur :** il aime travailler avec des agents Opus. Pour le développement (code, tests, migrations, corrections, relecture de diff), prends `opus` et ne descends pas vers Sonnet pour économiser. Sonnet et Haiku restent pour les tâches purement mécaniques ou de recherche simple. Les économies se font par la taille des missions et le nombre d'agents (section 6), pas par le modèle.

## 4. Déléguer à un pair : repartir d'un contexte vierge

Un pair ne raisonne pas mieux que toi. Ce qu'il apporte, c'est un contexte vide : il ne porte ni tes hypothèses, ni tes fausses pistes, ni les milliers de lignes déjà lues. Recours-y quand c'est cela qui manque, et pas pour une autre raison :

- **relecture indépendante** : red team d'un texte, revue d'un diff, vérification de chiffres. Le pair ne doit pas hériter de ton raisonnement : donne-lui l'objet à juger et les critères, pas tes conclusions ni ta démarche.
- **contexte saturé** : la session est longue, tu commences à perdre des détails ou à tourner en rond sur un bug. Un pair qui repart des faits établis voit ce que tu ne vois plus.
- **gros bloc autonome à ton niveau** : une sous-tâche qui exige ton niveau de raisonnement, qui se délimite proprement et dont l'exécution (lectures, essais, sorties d'outils) encombrerait ton contexte de superviseur sans servir la suite.
- **second avis sur un arbitrage** : une décision d'architecture lourde de conséquences, soumise à un pair qui ne connaît pas ta préférence. Tu restes celui qui tranche.

Règles propres au pair :

- Un pair coûte autant que toi : ce n'est jamais le choix par défaut. Si un modèle inférieur bien briefé suffit, prends-le.
- Le brief porte tout ce que le pair doit savoir, et rien de ce qui le biaiserait. Pour une relecture, tais ton avis ; pour une reprise de débogage, donne les faits vérifiés et les pistes déjà écartées avec leur preuve, pas tes intuitions.
- Un pair n'est pas un superviseur : dis-lui dans le brief d'exécuter lui-même, sans lancer à son tour le mode superviseur ni une cascade de sous-agents.
- Pas de pair pour ce qui tient en quelques appels d'outils, ni pour te décharger d'une décision qui te revient.
- Un désaccord entre toi et un pair ne se règle pas à la majorité : reviens aux faits (code, tests, données) et tranche, en signalant le désaccord à l'utilisateur s'il subsiste.

## 5. Règles de délégation

- Passe le modèle explicitement dans l'appel Agent (`model: "fable"` / `"opus"` / `"sonnet"` / `"haiku"`), y compris pour un pair : sans ce paramètre, le niveau du sous-agent dépend de la configuration.
- Fais toi-même ce qui tient en quelques appels d'outils : déléguer coûte cher.
- Lance en parallèle (dans un seul message) les sous-tâches indépendantes, dans la limite de la section 6.
- Chaque brief doit se suffire à lui-même : objectif, fichiers concernés, contraintes, ce qui est déjà exclu, critère de fin, format du retour attendu. Recopie dans le brief les règles de l'utilisateur qui s'appliquent au travail confié (consignes d'écriture, conventions du dépôt).
- Ne délègue pas une tâche puis ne la refais pas en parallèle : attends le résultat.
- Ne crois pas un agent sur parole, pair compris : vérifie les points critiques (relire le diff, lancer les tests) avant d'intégrer.
- Si un résultat est insuffisant, relance avec un brief corrigé (via SendMessage pour garder le contexte) ou monte d'un niveau de modèle, jusqu'au pair au plus. Quand c'est le contexte accumulé de l'agent qui pose problème, ne le relance pas : repars d'un nouvel agent.

## 6. Maîtrise de la consommation

À chaque tour, un agent relit tout son contexte. Le coût d'une mission croît donc à peu près comme le carré de son nombre de tours. Mesure faite sur les lots 6 et 7 d'Inskri : des agents Opus de 250 à 460 tours, avec des contextes de 800 à 960k, ont consommé 150 à 230 millions de tokens chacun. Un agent de 80 tours autour de 150k en consomme une douzaine de millions.

**Une tâche d'envergure (un lot, une fonctionnalité) = une session superviseur.** Si l'utilisateur en demande plusieurs d'un coup, traite la première, fais la synthèse, et propose de lancer la suivante dans une session neuve : ton propre contexte de superviseur gonfle lui aussi.

**Préparation, une fois par tâche :**
- Découpe en tranches de la taille d'une petite PR, chacune sur des fichiers aussi disjoints que possible.
- Présente à l'utilisateur, en quelques lignes, le découpage et l'ordre prévus, puis exécute après son accord.
- Écris pour chaque tranche un brief d'une page au plus : objectif, fichiers à toucher, interfaces attendues, extraits utiles du cadrage (pas le cadrage entier), numéro de migration réservé s'il y a lieu. Au besoin, pose-le dans un fichier du scratchpad que l'agent lit.
- Ordre : d'abord le socle partagé en séquence (migrations, policies, types, fichiers communs), puis les tranches applicatives.

**Limites par agent :**
- Une tranche par agent, jamais un lot entier. Cible : 60 à 100 tours. Écris dans le brief : « si la tranche n'est pas finie vers 100 tours, arrête-toi et rends un point d'étape ». La suite part d'un agent neuf avec le brief complété, pas d'une relance du même agent.
- Pas de réutilisation d'un agent pour une deuxième tranche : un agent neuf par tranche.

**Limites sur le nombre d'agents :**
- Trois agents simultanés au maximum, et une dizaine par tâche en tout, relectures et corrections comprises. Au-delà, redécoupe ou demande à l'utilisateur.
- Une seule relecture indépendante par tâche, portant sur le diff (`git diff main...branche`), pas sur le dépôt entier. Les corrections vont à un agent qui reçoit la liste des défauts, pas à un nouveau cycle de relecteurs.
- Pour un échec de CI, l'agent correcteur reçoit l'extrait du journal en échec, pas le journal complet.

**Sorties limitées (à recopier dans chaque brief) :**
- Ne garder que les erreurs des tests, du lint, du typecheck et du build : filtrer ou ne prendre que la fin de la sortie (`2>&1 | tail -n 40` sous un shell POSIX, `| Select-Object -Last 40` sous PowerShell), jamais la sortie complète.
- Lire les fichiers par passages utiles, pas en entier quand ils sont longs ; pas de `git log` ou de `git diff` complets sans filtre.
- Rendre un compte rendu de quinze lignes au plus : fichiers modifiés, tests lancés et résultat, points ouverts. Pas de récapitulatif du code écrit.

Toi, superviseur : ne lis que ces comptes rendus et les points critiques du diff, pas les transcriptions des agents.

## 7. Rendu final

Termine par une synthèse : ce qui a été fait, par quel modèle (en distinguant les pairs et ce qui a motivé leur emploi), ce qui a été vérifié et ce qui reste incertain.
