#!/bin/bash

# Variables d'entrée
GITHUB_USER=$1
REPO_NAME=$2
COMMITS=$3
GITHUB_TOKEN=$4

# Créer un fichier pour stocker les contributions
CONTRIBUTION_FILE="contributions/contribution_thread_$(basename "$0" .sh).txt"
mkdir -p "$(dirname "$CONTRIBUTION_FILE")" # S'assurer que le dossier existe
touch $CONTRIBUTION_FILE

# Effectuer les commits
for ((i=1; i<=COMMITS; i++)); do
  echo "Contribution $i dans le thread $(basename "$0" .sh)" >> $CONTRIBUTION_FILE
  git add $CONTRIBUTION_FILE
  git commit -m "Contribution $i du thread $(basename "$0" .sh)"
done

# Pousser les modifications
git push -u origin main
