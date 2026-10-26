# Projets BGC-Argo

Page web qui résume les projets suivis par Claude (sessions sur la VM oao2022, sur le Mac, et dépôts GitHub), avec trois figures par projet et un lien vers la page complète de graphiques de chacun.

- `index.html` : la page. Elle est aussi publiée comme page Claude privée.
- `img/` : les figures, copies réduites (1 600 px de large au plus) des graphiques de chaque projet.
- `installer_sur_vm.sh` : copie la page sur le site web de la VM.

## Mettre la page sur la VM

Sur la VM :

```bash
git clone https://github.com/antoine250/read_DOI.git   # ou git pull dans une copie existante
cd read_DOI
git checkout claude/projects-web-page-2v6sfb
./projets/installer_sur_vm.sh
```

La page est alors servie à `http://<adresse de la VM>/projets/`, à côté de `bioargo/` déjà utilisé par SOCA CLIM Light Argo. Pour un autre dossier : `./projets/installer_sur_vm.sh /chemin/du/dossier`.

Les liens « Ouvrir les graphiques » mènent aux pages claude.ai de chaque projet : elles sont privées et s'ouvrent avec ton compte Claude.

## Sur lov-oao, sans droits sur /var/www/html

La page est servie par un petit serveur Python dans `~/site`, sur le port 8765 : `http://lov-oao:8765/projets/`.

`mise_a_jour_lov_oao.sh` récupère la dernière version du dépôt, réinstalle la page dans `~/site/projets` et relance le serveur s'il est arrêté. Pour qu'il tourne tout seul, toutes les heures et au redémarrage de la machine :

```bash
(crontab -l 2>/dev/null
 echo '17 * * * * $HOME/read_DOI/projets/mise_a_jour_lov_oao.sh >> $HOME/site/mise_a_jour.log 2>&1'
 echo '@reboot $HOME/read_DOI/projets/mise_a_jour_lov_oao.sh >> $HOME/site/mise_a_jour.log 2>&1') | crontab -
```

Le contenu de la page (états, chiffres, figures) est refait par Claude à partir des pages de graphiques de chaque projet, puis poussé sur la branche : lov-oao le récupère au passage suivant du cron.
