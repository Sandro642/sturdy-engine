#!/bin/bash

# Demander les informations à l'utilisateur
read -p "Entrez votre pseudo GitHub : " GITHUB_USERNAME
read -p "Entrez le nom du dépôt distant : " REPO_NAME
read -p "Entrez le nombre de contributions : " CONTRIBUTIONS
read -p "Entrez le nombre de threads : " THREADS
read -p "Entrez votre token GitHub : " GITHUB_TOKEN

# Demander à l'utilisateur s'il souhaite voir les threads
read -p "Voulez-vous voir les $THREADS threads ? (oui/non) : " SEE_THREADS

# Lancer les threads
for ((i = 0; i < THREADS; i++)); do
    # Si l'utilisateur veut voir les threads, ouvrez une nouvelle fenêtre de terminal
    if [[ "$SEE_THREADS" == "oui" ]]; then
        # Ouvrir une nouvelle fenêtre de terminal et exécuter le script de commit
        gnome-terminal -- bash -c "./commit_thread.sh \"$GITHUB_USERNAME\" \"$REPO_NAME\" $((CONTRIBUTIONS / THREADS)) \"$GITHUB_TOKEN\" \"contributions/thread_$i\"; exec bash"
    else
        # Exécuter le script de commit en arrière-plan
        ./commit_thread.sh "$GITHUB_USERNAME" "$REPO_NAME" $((CONTRIBUTIONS / THREADS)) "$GITHUB_TOKEN" "contributions/thread_$i" &
    fi
done

# Attendre que tous les threads se terminent
wait

echo "Tous les commits ont été réalisés et poussés."

# Supprimer les dossiers des threads localement
for ((i = 0; i < THREADS; i++)); do
    # Supprimer le dossier des contributions pour chaque thread
    rm -rf "contributions/thread_$i"
done

# Supprimer les dossiers des threads dans le dépôt distant
# Vérifiez si le dépôt distant existe
if git ls-remote --exit-code origin &> /dev/null; then
    # Supprimer les dossiers dans le dépôt distant
    for ((i = 0; i < THREADS; i++)); do
        # Utiliser la commande git pour supprimer le dossier des contributions à distance
        git rm -r "contributions/thread_$i"
    done
    git commit -m "Supprimer les dossiers des threads après les commits"
    git push origin main
else
    echo "Le dépôt distant n'est pas accessible."
fi

echo "Les dossiers des threads ont été supprimés."
