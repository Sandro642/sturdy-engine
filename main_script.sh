#!/bin/bash

# Demande des informations utilisateur
read -p "Entrez votre pseudo GitHub : " GITHUB_USERNAME
read -p "Entrez le nom du dépôt distant : " REPO_NAME
read -p "Entrez le nombre de contributions : " CONTRIBUTIONS
read -p "Entrez le nombre de threads : " THREADS
read -sp "Entrez votre token GitHub : " GITHUB_TOKEN
echo ""
read -p "Voulez-vous voir les $THREADS threads ? (oui/non) : " SEE_THREADS

# Fonction pour vérifier les erreurs
check_error() {
    if [ $? -ne 0 ]; then
        echo "Une erreur est survenue."
        exit 1
    fi
}

# Lancer les threads
for ((i = 0; i < THREADS; i++)); do
    THREAD_DIR="contributions/thread_$i"  # Dossier du thread
    THREAD_BRANCH="thread_branch_$i"       # Branche spécifique pour chaque thread
    mkdir -p "$THREAD_DIR"                 # Créer le dossier
    check_error                            # Vérifie si le dossier a bien été créé

    # Lancer le thread dans un terminal ou en arrière-plan selon le choix de l'utilisateur
    if [[ "$SEE_THREADS" == "oui" ]]; then
        start bash -c "./commit_thread.sh \"$GITHUB_USERNAME\" \"$REPO_NAME\" $((CONTRIBUTIONS / THREADS)) \"$GITHUB_TOKEN\" \"$THREAD_DIR\" \"$THREAD_BRANCH\"; exec bash"
    else
        ./commit_thread.sh "$GITHUB_USERNAME" "$REPO_NAME" $((CONTRIBUTIONS / THREADS)) "$GITHUB_TOKEN" "$THREAD_DIR" "$THREAD_BRANCH" &
    fi
done

# Attendre que tous les threads se terminent
wait

# Fusionner chaque branche de thread dans la branche principale
for ((i = 0; i < THREADS; i++)); do
    THREAD_BRANCH="thread_branch_$i"
    git checkout main
    git merge "$THREAD_BRANCH" -m "Fusionner $THREAD_BRANCH dans main"
    check_error
done

# Pousser les modifications dans la branche principale
git push origin main
check_error

# Message final
echo "Les contributions ont été fusionnées et poussées dans la branche principale."
