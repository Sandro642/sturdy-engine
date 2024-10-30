#!/bin/bash

# Récupérer les arguments
GITHUB_USER=$1
REPO_NAME=$2
COMMITS=$3
THREADS=$4
GITHUB_TOKEN=$5

# Créer un dossier pour les contributions si ce n'est pas déjà fait
mkdir -p contributions

# Vérifier si le dépôt existe déjà
if git ls-remote --exit-code "https://github.com/$GITHUB_USER/$REPO_NAME.git" &>/dev/null; then
  echo "Le dépôt distant existe déjà."
else
  echo "Le dépôt distant n'existe pas."
  exit 1
fi

# Demander si l'utilisateur veut commencer le processus
read -p "Voulez-vous démarrer le processus de contributions (O/N) ? " START_PROCESS
if [[ ! $START_PROCESS =~ ^[Oo]$ ]]; then
  echo "Processus annulé."
  exit 0
fi

# Créer des threads
for ((t=1; t<=THREADS; t++)); do
  BRANCH_NAME="thread-$t"
  
  # Créer une nouvelle branche
  git checkout -b "$BRANCH_NAME"
  
  # Lancer le script de contribution dans un nouveau terminal
  start bash commit_thread.sh "$GITHUB_USER" "$REPO_NAME" "$COMMITS" "$GITHUB_TOKEN" "$BRANCH_NAME"
  
  # Revenir à la branche principale
  git checkout main
done

# Attendre la fin des threads
wait

# Supprimer les branches de thread
for ((t=1; t<=THREADS; t++)); do
  BRANCH_NAME="thread-$t"
  git branch -d "$BRANCH_NAME"
done

echo "Branches de thread supprimées. Processus terminé. Appuyez sur une touche pour quitter..."
read -n 1 -s
