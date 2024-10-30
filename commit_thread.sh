#!/bin/bash

# Récupérer les arguments
GITHUB_USER=$1
REPO_NAME=$2
COMMITS=$3
GITHUB_TOKEN=$4

# Boucle pour effectuer les commits
for ((i=1; i<=COMMITS; i++)); do
  # Créer un fichier de contribution
  echo "Contribution $i" > "contributions/contribution_thread_$i.txt"
  
  # Ajouter le fichier et faire un commit
  git add "contributions/contribution_thread_$i.txt"
  git commit -m "Contribution $i de $GITHUB_USER"

  # Simuler un délai pour représenter le travail effectué
  sleep 1
done

# Pousser les contributions vers le dépôt distant
git push origin main
