#!/bin/bash

# Demander les informations de l'utilisateur
read -p "Entrez votre pseudo GitHub : " username
read -p "Entrez le nom du dépôt distant : " repo_name
read -p "Entrez le nombre de contributions : " num_contributions
read -p "Entrez le nombre de threads : " num_threads
read -s -p "Entrez votre token GitHub : " github_token
echo
read -p "Voulez-vous voir les threads ? (oui/non) : " voir_threads

# Calculer le nombre de commits par thread
commits_per_thread=$((num_contributions / num_threads))

# Créer les contributions dans chaque thread
for ((i=0; i<num_threads; i++)); do
    (
        # Nom de la branche pour chaque thread
        thread_branch="thread_branch_$i"
        git checkout -b "$thread_branch" main

        # Créer les commits pour ce thread
        for ((j=1; j<=commits_per_thread; j++)); do
            # Créer un fichier unique pour chaque commit
            touch "contributions/thread_$i/commit_$j.txt"
            echo "Contribution $j par $username" > "contributions/thread_$i/commit_$j.txt"
            git add "contributions/thread_$i/commit_$j.txt"
            git commit -m "Ajout du commit $j par $username"
            
            # Affichage conditionnel des logs
            if [ "$voir_threads" = "oui" ]; then
                echo "Thread $i: Commit $j créé et ajouté"
            fi
        done

        # Fusionner la branche du thread dans main
        git checkout main
        git merge --no-ff "$thread_branch" -m "Fusion de $thread_branch dans main"
        git branch -D "$thread_branch" # Supprimer la branche du thread

    ) &
done

# Attendre la fin de tous les threads
wait

# Pousser les contributions par lot
echo "Envoi des contributions en cours..."
git push origin main --force
