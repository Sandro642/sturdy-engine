#!/bin/bash

# Récupérer les arguments ou demander les valeurs si non fournies
GITHUB_USER=${1}
REPO_NAME=${2}
COMMITS=${3}
GITHUB_TOKEN=${4}
BRANCH_NAME=${5}

# Si les arguments ne sont pas fournis, demander les valeurs
if [ -z "$GITHUB_USER" ]; then
  read -p "Nom d'utilisateur GitHub : " GITHUB_USER
fi

if [ -z "$REPO_NAME" ]; then
  read -p "Nom du dépôt distant : " REPO_NAME
fi

if [ -z "$COMMITS" ]; then
  read -p "Nombre de commits : " COMMITS
fi

if [ -z "$GITHUB_TOKEN" ]; then
  read -p "Token GitHub : " GITHUB_TOKEN
fi

# Changer vers le bon dépôt
cd "$REPO_NAME" || exit

# Créer un dossier pour les contributions si ce n'est pas déjà fait
mkdir -p contributions

# Passer à la branche de thread
git checkout "$BRANCH_NAME"

# Créer des contributions
for ((i=1; i<=COMMITS; i++)); do
  # Créer un fichier de contribution
  echo "Contribution $i de $GITHUB_USER dans le dépôt $REPO_NAME" > "contributions/contribution_thread_$i.txt"
  
  # Ajouter le fichier à l'index
  git add "contributions/contribution_thread_$i.txt"
  
  # Faire un commit
  git commit -m "Ajout de contribution $i de $GITHUB_USER"
  
  echo "Contribution $i ajoutée."
  sleep 1 # Ajouter un délai pour éviter les conflits
done

# Pousser les changements vers le dépôt distant
git push origin "$BRANCH_NAME"

echo "Contributions terminées pour le thread $BRANCH_NAME."

# Demander si l'utilisateur veut fermer la fenêtre
read -p "Voulez-vous fermer cette fenêtre ? (O/N) " CLOSE_WINDOW
if [[ $CLOSE_WINDOW =~ ^[Oo]$ ]]; then
  exit 0
else
  echo "La fenêtre restera ouverte."
  read -p "Appuyez sur une touche pour continuer..."
fi
