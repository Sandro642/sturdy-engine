#!/bin/bash

# Arguments
github_username=$1
num_contributions=$2

# Boucle de création de commits
for i in $(seq 1 $num_contributions); do
    # Crée un fichier pour chaque contribution
    echo "Contribution $i par $github_username" > "commit_$i.txt"
    
    # Ajouter et commiter chaque contribution
    git add "commit_$i.txt"
    git commit -m "Ajout de la contribution $i par $github_username"
    
    echo "Contribution $i créée."
done

echo "Tous les commits ont été créés localement."
