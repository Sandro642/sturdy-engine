#!/bin/bash

# Fonction pour vérifier si le dossier est un dépôt Git
check_git_repo() {
  if [ ! -d ".git" ]; then
    echo "Initialisation d'un nouveau dépôt Git..."
    git init
  fi
}

# Demander les informations à l'utilisateur
read -p "Nom d'utilisateur GitHub : " GITHUB_USER
read -p "Nom du dépôt distant : " REPO_NAME
read -p "Nombre de commits : " TOTAL_COMMITS
read -p "Nombre de threads : " THREADS
read -p "Token GitHub : " GITHUB_TOKEN

# Vérification du dossier et initialisation si nécessaire
check_git_repo

# Ajouter le dépôt distant
git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git" 2>/dev/null || echo "Le dépôt distant existe déjà."

# Calculer le nombre de commits par thread
COMMITS_PER_THREAD=$(( (TOTAL_COMMITS + THREADS - 1) / THREADS )) # On s'assure de répartir les commits correctement

# Créer un dossier pour les contributions
mkdir -p contributions

# Demander si l'utilisateur veut démarrer le processus de contributions
read -p "Voulez-vous démarrer le processus de contributions (O/N) ? " START_PROCESS
if [[ ! $START_PROCESS =~ ^[Oo]$ ]]; then
  echo "Processus annulé."
  exit 0
fi

# Créer et lancer les threads
for ((i=1; i<=THREADS; i++)); do
  # Créer une branche pour chaque thread
  THREAD_BRANCH="thread-$i"
  git checkout -b $THREAD_BRANCH
  
  # Exécuter le script de thread dans un terminal séparé
  # Utilisation de cmd pour Windows
  start cmd /k "bash commit_thread.sh $GITHUB_USER $REPO_NAME $COMMITS_PER_THREAD $GITHUB_TOKEN; pause" &
  
  # Revenir à la branche principale
  git checkout main
done

# Suppression des branches après exécution
for ((i=1; i<=THREADS; i++)); do
  git branch -d "thread-$i"
done

# Suppression du dossier de contributions après les commits
rm -rf contributions

# Pousser les changements vers le dépôt distant
git add .
git commit -m "Supprimer le dossier de contributions"
git push origin main

echo "Processus terminé."
