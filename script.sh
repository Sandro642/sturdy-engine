#!/bin/bash

# Demande à l'utilisateur le nombre de contributions, le dépôt, le token GitHub et le nombre de "threads"
read -p "Combien de contributions veux-tu faire (par ex., 50, 100, 1000) ? " count
read -p "Nom de l'utilisateur GitHub : " username
read -p "Nom du dépôt : " repository
read -sp "Token GitHub (il ne sera pas affiché) : " token
echo
read -p "Nombre de threads (processus simultanés, par ex., 2, 4, 8) ? " threads

# Vérifie que les entrées sont valides
if ! [[ "$count" =~ ^[0-9]+$ ]] || ! [[ "$threads" =~ ^[0-9]+$ ]]; then
  echo "Entrée invalide. Veuillez entrer un nombre pour les contributions et les threads."
  exit 1
fi

# Délai de 1 seconde entre chaque commit (peut être ajusté si nécessaire)
delay=1

# Calcul du nombre de contributions par thread
count_per_thread=$((count / threads))

# Fonction pour gérer les contributions dans un thread
commit_and_push() {
  local thread_id=$1
  local commits=$2
  for i in $(seq 1 $commits)
  do
    # Ajoute une ligne unique pour chaque thread pour éviter les conflits de commit
    echo "Contribution automatique (Thread #$thread_id) #$i" >> contributions_thread_$thread_id.txt

    # Ajoute, commit et push les modifications
    git add contributions_thread_$thread_id.txt
    git commit -m "Contribution #$i par Thread #$thread_id"
    git push origin main

    # Pause pour éviter de surcharger GitHub
    sleep $delay
  done
}

# Lancement des threads
for t in $(seq 1 $threads)
do
  # Appelle la fonction en arrière-plan pour chaque thread
  commit_and_push $t $count_per_thread &
done

# Attente de la fin de tous les processus
wait

echo "Contributions terminées avec succès !"
