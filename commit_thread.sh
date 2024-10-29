#!/bin/bash

GITHUB_USERNAME=$1
REPO_NAME=$2
COMMITS=$3
GITHUB_TOKEN=$4
THREAD_DIR=$5

# Assurez-vous que le répertoire de threads existe
mkdir -p "$THREAD_DIR"

# Configurer Git
git config --global user.name "$GITHUB_USERNAME"
git config --global user.email "${GITHUB_USERNAME}@users.noreply.github.com"

# Naviguer vers le répertoire de travail
cd "$THREAD_DIR" || exit

for ((i = 1; i <= COMMITS; i++)); do
    # Créer un fichier de commit
    echo "Contenu du commit $i" > "commit_$i.txt"

    # Ajouter le fichier avant de le commettre
    git add "commit_$i.txt"

    # Effectuer le commit
    git commit -m "Ajout du commit $i par $GITHUB_USERNAME"

    # Pousser les modifications
    git push "https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$REPO_NAME.git" main
done
