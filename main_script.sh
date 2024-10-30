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
git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"

# Calculer le nombre de commits par thread
COMMITS_PER_THREAD=$(( (TOTAL_COMMITS + THREADS - 1) / THREADS )) # On s'assure de répartir les commits correctement

# Créer un dossier pour les contributions
mkdir -p contributions

# Demander si l'utilisateur veut voir les processus des threads
read -p "Voulez-vous voir les processus des threads en cours (O/N) ? " VIEW_THREADS

# Demander si l'utilisateur veut démarrer le processus de contributions
read -p "Voulez-vous démarrer le processus de contributions (O/N) ? " START_CONTRIBUTIONS

# Créer et lancer les threads si l'utilisateur souhaite démarrer le processus
if [[ $START_CONTRIBUTIONS =~ ^[Oo]$ ]]; then
  for ((i=1; i<=THREADS; i++)); do
    # Créer une branche pour chaque thread
    THREAD_BRANCH="thread-$i"
    git checkout -b $THREAD_BRANCH
    
    # Exécuter le script de thread dans un terminal séparé (si l'utilisateur a choisi de voir les processus)
    if [[ $VIEW_THREADS =~ ^[Oo]$ ]]; then
      start "Thread $i" bash -c "./commit_thread.sh $GITHUB_USER $REPO_NAME $COMMITS_PER_THREAD $GITHUB_TOKEN; read -p 'Press any key to continue...' var" &
    else
      ./commit_thread.sh $GITHUB_USER $REPO_NAME $COMMITS_PER_THREAD $GITHUB_TOKEN
    fi
    
    # Revenir à la branche principale
    git checkout main
  done

  # Si l'utilisateur a choisi de voir les processus, on demande de continuer
  if [[ $VIEW_THREADS =~ ^[Oo]$ ]]; then
    for ((i=1; i<=THREADS; i++)); do
      start "Processus du thread $i" bash -c "echo 'Processus du thread $i'; tail -f contributions/contribution_thread_$i.txt; read -p 'Press any key to continue...' var" &
    done
  fi

  # Attendre que tous les threads soient terminés avant de fusionner
  for ((i=1; i<=THREADS; i++)); do
    THREAD_BRANCH="thread-$i"
    
    # Fusionner chaque branche de thread dans la branche principale
    git merge $THREAD_BRANCH
    # Supprimer la branche de thread
    git branch -d $THREAD_BRANCH
  done

  # Pousser les modifications vers le dépôt distant
  git push -u origin main

  # Supprimer le dossier des contributions localement
  rm -rf contributions

  # Supprimer le dossier des contributions dans le dépôt distant
  git rm -r contributions
  git commit -m "Supprimer le dossier de contributions"
  git push origin main
else
  echo "Le processus de contributions a été annulé."
fi
