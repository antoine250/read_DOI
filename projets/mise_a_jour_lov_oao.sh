#!/usr/bin/env bash
# Met à jour la page des projets sur lov-oao : récupère la dernière version du dépôt,
# réinstalle la page dans ~/site/projets, et relance le petit serveur web s'il est arrêté.
#
# À lancer à la main, ou par cron (voir projets/README.md) :
#   ~/read_DOI/projets/mise_a_jour_lov_oao.sh
set -euo pipefail

DEPOT="$(cd "$(dirname "$0")/.." && pwd)"
SITE="${SITE:-$HOME/site}"
PORT="${PORT:-8765}"
BRANCHE="${BRANCHE:-claude/projects-web-page-2v6sfb}"

cd "$DEPOT"
git fetch -q origin "$BRANCHE"
git checkout -q "$BRANCHE"
git merge -q --ff-only "origin/$BRANCHE"
./projets/installer_sur_vm.sh "$SITE/projets" > /dev/null

if ! curl -s -o /dev/null "http://localhost:$PORT/"; then
  (cd "$SITE" && nohup python3 -m http.server "$PORT" > serveur.log 2>&1 &)
  sleep 1
  echo "$(date '+%F %T') serveur relancé sur le port $PORT"
fi

echo "$(date '+%F %T') page à jour (version $(git rev-parse --short HEAD))"
