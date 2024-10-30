#!/bin/bash

echo -n "Entrez votre pseudo GitHub : "
read github_username
echo -n "Entrez le nom du dépôt distant : "
read repo_name
echo -n "Entrez le nombre de contributions : "
read num_contributions
echo -n "Entrez votre token GitHub : "
read -s github_token
echo

# Vérifie si le répertoire contributions existe, sinon le créer
mkdir -p contributions
cd contributions

# Lancer le script de création de commits en parallèle
bash ../commit_thread.sh $github_username $num_contributions

# Revenir au dossier principal
cd ..

# Effectuer un seul push à la fin après avoir créé tous les commits
echo "Envoi des contributions sur GitHub..."
git push origin main
echo "Toutes les contributions ont été envoyées avec succès."
