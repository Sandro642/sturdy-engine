#!/bin/bash

# Fonction pour afficher un message d'erreur
function error() {
    echo "Erreur : $1"
    exit 1
}

# Demander les informations à l'utilisateur
read -p "Entrez votre pseudo GitHub : " GITHUB_USERNAME
read -p "Entrez le nom du dépôt distant : " REPO_NAME
read -p "Entrez le nombre de contributions : " TOTAL_COMMITS
read -p "Entrez le nombre de threads : " TOTAL_THREADS
read -sp "Entrez votre token GitHub : " GITHUB_TOKEN
echo

# Vérifier que les entrées sont valides
if ! [[ "$TOTAL_COMMITS" =~ ^[0-9]+$ ]] || ! [[ "$TOTAL_THREADS" =~ ^[0-9]+$ ]]; then
    error "Le nombre de contributions et de threads doit être un nombre entier."
fi

# Créer les répertoires pour les logs et les contributions
mkdir -p logs contributions

# Calculer le nombre de commits par thread
COMMITS_PER_THREAD=$((TOTAL_COMMITS / TOTAL_THREADS))
EXTRA_COMMITS=$((TOTAL_COMMITS % TOTAL_THREADS))

# Démarrer les threads
for ((i = 0; i < TOTAL_THREADS; i++)); do
    THREAD_COMMITS=$COMMITS_PER_THREAD
    # Distribuer les commits restants
    if [[ $i -lt $EXTRA_COMMITS ]]; then
        THREAD_COMMITS=$((THREAD_COMMITS + 1))
    fi

    # Créer un fichier pour les contributions du thread
    THREAD_DIR="contributions/thread_$i"
    mkdir -p "$THREAD_DIR"

    # Exécuter le script de thread et afficher les logs dans la console
    echo "Démarrage du thread $i avec $THREAD_COMMITS commits..."
    bash commit_thread.sh "$GITHUB_USERNAME" "$REPO_NAME" "$THREAD_COMMITS" "$GITHUB_TOKEN" "$THREAD_DIR"

    # Attendre que le thread soit terminé avant de continuer
    echo "Thread $i terminé."
done

echo "Tous les commits ont été réalisés et poussés."
