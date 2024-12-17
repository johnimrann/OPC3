# Projet Salesforce Lightning - Visualiseur d'Opportunités

## Description
Ce projet implémente un composant Lightning Web Component pour visualiser et gérer les opportunités liées à un compte dans Salesforce. Il met en œuvre les meilleures pratiques de développement Salesforce et offre une interface utilisateur moderne et réactive.

## Structure du Projet

### Composants Lightning
- `accountOpportunitiesViewer` : Composant principal pour l'affichage des opportunités

### Classes Apex
- `OpportunitySelector` : Gestion des requêtes SOQL et accès aux données
- `OpportunitySelectorTest` : Tests unitaires

## Fonctionnalités

1. **Affichage des Opportunités**
   - Liste triable des opportunités
   - Compteur d'opportunités
   - Formatage des montants et dates

2. **Gestion des Données**
   - Mise en cache des requêtes
   - Validation des entrées
   - Gestion des erreurs

3. **Interface Utilisateur**
   - Design moderne avec SLDS
   - États de chargement
   - Messages d'erreur explicites

## Installation

1. Cloner le repository :
```bash
git clone [URL_DU_REPO]
```

2. Déployer vers votre org Salesforce :
```bash
sfdx force:source:deploy -p force-app
```

## Développement

### Historique des Modifications
Consultez le fichier `git_history.md` pour un historique détaillé des modifications avec les commits correspondants.

### Tests
Pour exécuter les tests :
```bash
sfdx force:apex:test:run -n OpportunitySelectorTest -r human
```

## Bonnes Pratiques

1. **Code**
   - Suivre les conventions de nommage Salesforce
   - Documenter le code
   - Écrire des tests unitaires

2. **Git**
   - Commits atomiques
   - Messages de commit descriptifs
   - Branches pour les fonctionnalités

3. **Sécurité**
   - Valider les entrées
   - Utiliser with sharing/inherited sharing
   - Gérer les exceptions

## Support
Pour toute question ou problème, consultez la documentation ou ouvrez une issue sur le repository.

## Auteur
[Votre Nom]

## Licence
Ce projet est sous licence [TYPE_DE_LICENCE]
