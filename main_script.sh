#!/bin/bash

# Vérifier si le dossier actuel est un dépôt Git
if [ ! -d ".git" ]; then
  echo "Initialisation d'un nouveau dépôt Git..."
  git init
fi

# Demander les informations à l'utilisateur
read -p "Entrez votre nom d'utilisateur GitHub : " GITHUB_USER
read -p "Entrez le nom du dépôt distant : " REPO_NAME
read -p "Entrez le nombre de commits : " COMMITS
read -p "Entrez le nombre de threads : " THREADS
read -p "Entrez votre token GitHub : " GITHUB_TOKEN

# Calculer le nombre de commits par thread
COMMITS_PER_THREAD=$((COMMITS / THREADS))

# Créer un dossier pour les contributions
mkdir -p contributions

# Boucle pour créer des branches et démarrer des threads
for ((i=1; i<=THREADS; i++)); do
  BRANCH_NAME="thread-$i"
  
  # Créer une nouvelle branche
  git checkout -b $BRANCH_NAME
  
  # Lancer le script de commit dans un nouveau terminal
  start bash commit_thread.sh "$GITHUB_USER" "$REPO_NAME" "$COMMITS_PER_THREAD" "$GITHUB_TOKEN" "$BRANCH_NAME"
  
  # Revenir à la branche principale
  git checkout main
done

echo "Tous les threads ont été lancés."

# Attendre que tous les threads soient terminés
wait

# Supprimer le dossier des contributions
rm -rf contributions

echo "Le dossier des contributions a été supprimé."
