# Snake

Le but du projet est d’implémenter le jeu du Snake. Il n’y a rien à installer à part le projet en lui-même, ainsi que Node.js et Yarn (ou NPM).

# Installation du projet

```bash
git clone git@github.com:ghivert/snake.git
cd snake
yarn install # npm install
```

# Le lancer

```bash
yarn start # npm start
```

# En cas de bug

```bash
rm -rf node_modules
yarn install
```

# Instructions

Pour rappel, le snake est un jeu sur une grille consistant à orienter à l'aide des flèches directionnels un serpent sur des pommes. Le serpent ne peut tourner que de 90° par tour de jeu. À chaque fois que celui-ci mange une pomme, son corps grandit d'une case. Il ne doit pas se cogner contre les murs ou contre lui-même.

Il est demandé :

1. Coder un snake sans mur (le monde sera torique) sur une grille de 40x40.
2. Ajouter des murs tout autour de l'espace de jeu. Ceux-ci devront être activables et désactivables.
3. Ajouter un compteur de score : chaque pomme mangé fait gagner 100 points et chaque seconde passée fait gagner 10 points.
4. Ajouter des cerises qui font gagner 100 points sans faire grandir le serpent. La cerise devrait disparaître au bout de 10 secondes.
5. Ajouter des murs randomisés au milieu de la grille si l'utilisateur le demande.
6. Ajouter la possibilité de choisir la taille de la grille.

## Bonus

- Ajouter un multijoueur avec ZKSD
- Ajouter une bombe qui réduit la taille du snake
- Ce qui vous inspire !

# Un exemple ?

On trouve de nombreux démineurs en ligne : [comme ici](https://poki.com/fr/g/snake-cool) ou encore [directement sur Google](https://www.google.com/fbx?fbx=snake_arcade).

# Implémentation

Le frontend et tout le déroulement est laissé à la libre appréciation de chacun.
