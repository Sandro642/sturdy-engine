#!/bin/bash

# Variables
read -p "Entrez votre pseudo GitHub : " github_user
read -p "Entrez le nom du dépôt distant : " repo_name
read -p "Entrez le nombre de contributions : " contribution_count
read -p "Entrez le nombre de threads : " thread_count
read -s -p "Entrez votre token GitHub : " github_token
echo ""
read -p "Voulez-vous voir les threads ? (oui/non) : " show_threads

# Crée un verrou temporaire
LOCKFILE=.git_commit_lock

# Fonction pour gérer les commits
function commit_contribution() {
    local thread_id=$1
    local count=1

    # Crée une nouvelle branche pour chaque thread
    git checkout -b "thread_branch_$thread_id"

    while [ $count -le $contribution_count ]; do
        # Crée un fichier de contribution
        contribution_file="contributions/thread_${thread_id}/commit_${count}.txt"
        mkdir -p "$(dirname "$contribution_file")"
        echo "Contribution #${count} du thread #${thread_id}" > "$contribution_file"

        # Ajout au commit
        git add "$contribution_file"

        # Gestion du verrou pour le commit
        (
            flock -n 9 || exit 1

            # Création du commit
            git commit -m "Thread ${thread_id}: Commit ${count} créé et ajouté"

        ) 9>"$LOCKFILE" # Redirige le fichier de verrou

        if [[ $? -eq 1 ]]; then
            echo "Thread ${thread_id}: en attente pour le verrou sur le commit ${count}"
            sleep 1
            continue
        fi

        if [[ $show_threads == "oui" ]]; then
            echo "Thread ${thread_id}: Commit ${count} créé et ajouté"
        fi

        count=$((count + 1))
    done

    # Pousse les changements pour chaque branche
    git push -u origin "thread_branch_$thread_id"
}

# Lancement des threads
for ((i=0; i<thread_count; i++)); do
    commit_contribution "$i" &
done

wait

# Nettoyage du fichier de verrou
rm -f "$LOCKFILE"

echo "Tous les commits ont été créés et poussés."
