#!/bin/bash

GITHUB_USER=$1
REPO_NAME=$2
COMMITS=$3
GITHUB_TOKEN=$4

# Créer des contributions
for ((i=1; i<=COMMITS; i++)); do
  # Créer un fichier de contribution
  echo "Contribution $i de $GITHUB_USER dans le dépôt $REPO_NAME" > "contributions/contribution_thread_$i.txt"
  
  # Ajouter le fichier à l'index
  git add "contributions/contribution_thread_$i.txt"
  
  # Faire un commit
  git commit -m "Ajout de contribution $i de $GITHUB_USER"
done

# Pousser les changements vers le dépôt distant
git push origin main

echo "Contributions terminées pour le thread."
