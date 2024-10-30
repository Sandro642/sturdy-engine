#!/bin/bash

GITHUB_USER=$1
REPO_NAME=$2
COMMITS=$3
GITHUB_TOKEN=$4
BRANCH_NAME=$5

# Changer de branche
git checkout $BRANCH_NAME

# Effectuer les commits
for ((i=1; i<=COMMITS; i++)); do
  # Créer un fichier avec un message de commit
  echo "Contribution $i dans la branche $BRANCH_NAME" > "contribution_$i.txt"
  
  # Ajouter et committer le fichier
  git add "contribution_$i.txt"
  git commit -m "Contribution $i"
done

# Pousser les changements vers le dépôt distant
git push https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$GITHUB_USER/$REPO_NAME.git $BRANCH_NAME

# Fusionner la branche avec la branche principale
git checkout main
git merge $BRANCH_NAME
git push https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$GITHUB_USER/$REPO_NAME.git main

echo "Contributions envoyées vers le dépôt distant."
