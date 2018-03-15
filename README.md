# Détection de fissures (basé sur Pottslab)

## Installation
1. Installer Pottslab : [Ici](https://github.com/mstorath/Pottslab)
2. Coller le dossier `Crack_detection` à la racine du dossier `Pottslab`

## Utilisation
Exécuter `crack_detection.m`.
**Remarque 1 :** il peut être nécessaire de jouer avec certains paramètres du modèle (ils sont signalés dans le code).
**Remarque 2 :** l'utilisation de la fonction `reduce_specularity` permet d'utiliser un paramètre `gamma` plus petit. Sur des images couleurs, des artefacts (du rose ou du vert en général) peuvent apparaitre.

## Description rapide des traitements effectués
1. Utilisation du filtre de Frangi
2. Résolution du problème de Potts avec les poids du filtre de Frangi
3. Soustraction entre l'image de départ et le résultat.
4. Pour supprimer le bruit restant, deux possibilités :
..* Débruitage par la variation totale
..* Deuxième possibilité :
.... 1. Deuxième utilisation du filtre de Frangi
.... 2. Deuxième résolution du problème de Potts
.... 3. Le bruit restant est traité comme un bruit poivre et sel (filtre median)

## Paramètres utilisés pour les exemples
Pour `baltazard-12.bmp`
```
Gamma = 10
Lambda = 0.06
Gamma2 = 1.1
neiSize = 2
```

Pour `0959.png` et `fissure1.jpg`
```
Gamma = 16
Lambda = 0.06
Gamma2 = 1.1
neiSize = 2
```

## Codes utilisés
* Pottslab
* [Filtre de Frangi](https://fr.mathworks.com/matlabcentral/fileexchange/24409-hessian-based-frangi-vesselness-filter) (version *très* légèrement modifiée)