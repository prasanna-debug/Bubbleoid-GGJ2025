# 20250126 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* choix des images pour les bulles et export Pascal sous forme de PNG et de SVG
* création de l'icone du jeu et association au projet
* conversion de la boite de dialogue créée hier en scène à part entière pour simplifier les traductions et la prise en charge des contrôles utilisateur
* diverses modifications pour adapter l'affichage de la boite de dialogue à la scène sur laquelle elle se trouve
* finalisation de l'écran d'accueil
* mise en place de l'écran des crédits du jeu
* mise en place de l'écran de fin de partie (perdue)
* mise à jour de la doc (description du jeu et partie installation+site)
* mise à jour du texte de description de l'application pour la boite de dialogue "à propos" et les crédits du jeu
* ajout du référencement des SVG des bulles provenant de Adobe Stock sur le projet
* basculement du champ de bulles du projet de test vers le jeu en scène de background (pour être affiché partout)
* optimisation du fonctionnement pour conserver des temps de réponse et une fluidité de l'affichage par rapport à ce qu'on avait dans le test qui speedait beaucoup plus
* création de l'écran de jeu
* ajout du fonctionnement de base (changement du nombre de vies et du score) sur la scène de background au niveau du calcul de collisions
* ajout de l'affichage du score sur l'écran de jeu
* ajout de l'affichage du nombre de vies sur l'écran de jeu
* mise en place de flashs colorés pour montrer qu'on a gagné ou perdu une vie sans avoir à regarder les coeurs restants
* ajout d'un bouton PAUSE sur l'écran de jeu pour quitter une partie (ESC au clavier, clic sur bouton pour souris et tactile, X pour game controller)
* nettoyage des HitTest sur les éléments ajoutés sur l'écran de jeu
* prise en charge du D-Pad des contrôleurs de jeu pour bouger pendant une partie (mais en event, donc pas idéal)
* prise en charge des sticks des contrôleurs de jeu pour bouger pendant une partie (mais en event, donc pas idéal)
* mise à jour des informations de déploiement dans les informations de version du projet
* déclaration du jeu sur le site de la Global Game Jam 2025 et publication d'une version Windows & Mac
* ajout de la configuration liée à Dproj2WinSetup pour la création des installeurs Windows 32&64 bits signés
