#!/bin/bash

# Vérifier les arguments
if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <GITHUB_USER> <REPO_NAME> <COMMITS_PER_THREAD> <GITHUB_TOKEN>"
  exit 1
fi

GITHUB_USER=$1
REPO_NAME=$2
COMMITS_PER_THREAD=$3
GITHUB_TOKEN=$4

# Changer dans le dossier des contributions
cd contributions || exit

# Exécuter les commits
for ((i=1; i<=COMMITS_PER_THREAD; i++)); do
  # Créer un fichier de commit avec un contenu aléatoire
  echo "Contribution de commit $i dans le thread..." > "contribution_thread_$i.txt"
  
  # Ajouter le fichier au dépôt
  git add "contribution_thread_$i.txt"
  
  # Faire un commit
  git commit -m "Contribution de commit $i dans le thread"
  
  # Afficher l'état actuel
  git status
done

# Revenir au répertoire principal
cd ..

# Terminer le script
exit 0
