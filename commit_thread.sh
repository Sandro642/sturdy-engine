#!/bin/bash

GITHUB_USERNAME="$1"
REPO_NAME="$2"
CONTRIBUTIONS="$3"
GITHUB_TOKEN="$4"
THREAD_DIR="$5"
THREAD_BRANCH="$6"

# Créer et se déplacer dans la branche du thread
git checkout -b "$THREAD_BRANCH"

# Boucle de création et de commit pour chaque contribution
for ((i = 1; i <= CONTRIBUTIONS; i++)); do
    COMMIT_FILE="$THREAD_DIR/commit_$i.txt"
    echo "Contribution $i par $GITHUB_USERNAME" > "$COMMIT_FILE"  # Crée un fichier de commit
    git add "$COMMIT_FILE"                                       # Ajoute le fichier au staging
    git commit -m "Ajout du commit $i par $GITHUB_USERNAME"      # Commit avec un message
    sleep 1                                                      # Pause pour simuler un délai entre les commits
done

# Pousser la branche du thread sur le dépôt distant
git push origin "$THREAD_BRANCH"
