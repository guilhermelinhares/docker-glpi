# Docker Glpi  Alpine


![GLPI Logo](https://raw.githubusercontent.com/glpi-project/glpi/main/pics/logos/logo-GLPI-250-black.png)

## About GLPI

GLPI stands for **Gestionnaire Libre de Parc Informatique** is a Free Asset and IT Management Software package, that provides ITIL Service Desk features, licenses tracking and software auditing.

## Variables

Configure variables DB in file db.env

```
MYSQL_ROOT_PASSWORD=.ROOT.DEV@2022.
MYSQL_DATABASE=glpi
MYSQL_USER=glpi
MYSQL_PASSWORD=.GLPiDB@2021.
TZ=America/Fortaleza

```


## Setting Up

First clone this repository, then run:

```
docker-compose up -d
```
