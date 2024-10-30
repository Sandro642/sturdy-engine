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
COMMITS_PER_THREAD=$(( TOTAL_COMMITS / THREADS ))
EXTRA_COMMITS=$(( TOTAL_COMMITS % THREADS )) # Commits supplémentaires à répartir

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

  # Calculer le nombre de commits pour ce thread
  if [ $i -le $EXTRA_COMMITS ]; then
    THREAD_COMMITS=$(( COMMITS_PER_THREAD + 1 )) # Ajoute 1 commit supplémentaire pour les premiers threads
  else
    THREAD_COMMITS=$COMMITS_PER_THREAD
  fi

  # Exécuter le script de thread dans un nouveau terminal
  start bash commit_thread.sh "$GITHUB_USER" "$REPO_NAME" "$THREAD_COMMITS" "$GITHUB_TOKEN"

  # Revenir à la branche principale
  git checkout main
done

# Suppression des branches après exécution
for ((i=1; i<=THREADS; i++)); do
  git branch -d "thread-$i"
done

echo "Processus terminé."
