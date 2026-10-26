#!/usr/bin/env bash
# Installe la page des projets sur le site web de la VM (Apache sert /var/www/html).
#
# Usage, depuis la VM, dans une copie du dépôt read_DOI :
#   ./projets/installer_sur_vm.sh                 # installe dans /var/www/html/projets
#   ./projets/installer_sur_vm.sh /autre/dossier  # installe ailleurs
#
# La page est ensuite visible à l'adresse http://<adresse de la VM>/projets/
set -euo pipefail

ICI="$(cd "$(dirname "$0")" && pwd)"
DEST="${1:-/var/www/html/projets}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# index.html est écrit pour une page Claude (sans <html>, <head> ni <body>) : on ajoute l'enveloppe.
{
  printf '<!doctype html>\n<html lang="fr">\n<head>\n<meta charset="utf-8">\n'
  printf '<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">\n'
  printf '</head>\n<body>\n'
  cat "$ICI/index.html"
  printf '\n</body>\n</html>\n'
} > "$TMP/index.html"

SUDO=""
if [ -d "$DEST" ]; then
  [ -w "$DEST" ] || SUDO="sudo"
else
  [ -w "$(dirname "$DEST")" ] || SUDO="sudo"
fi

$SUDO mkdir -p "$DEST/img"
$SUDO cp "$TMP/index.html" "$DEST/index.html"
$SUDO cp "$ICI"/img/*.jpg "$DEST/img/"
$SUDO chmod -R a+rX "$DEST"

echo "Page installée dans $DEST"
