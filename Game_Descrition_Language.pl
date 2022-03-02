#Misère Nim :
#On a un tas de 6 allumettes.
#Chaque joueur à son tour prend 1, 2 ou 3 allumettes.
#Le dernier qui joue a perdu.
#Ecrire le graphe d'états du jeu.
#Modéliser ce jeu en GDL.

role(joueur 1)
role(joueur 2)

succ(6, 5)
succ(6, 4)
succ(6, 3)
succ(5, 4)
succ(5, 3)
succ(5, 2)
succ(4, 3)
succ(4, 2)
succ(4, 1)
succ(3, 2)
succ(3, 1)
succ(3, 0)
succ(2, 1)
succ(2, 0)
succ(1, 0)

init(nb(6))
init(control(joueur 1))

legal(J, Y) :- nb(X) & succ(X, Y) & control(J)
legal(J, noop) :- not control(J)

next(nb(Y)) :- does(J, Y) & control(J)
next(control(joueur 1)) :- control(joueur 2)
next(control(joueur 2)) :- control(joueur 1)

terminal :- nb(0)

goal(joueur, 100) :- control(J) & nb(0)
goal(joueur 1, 0) :- control(joueur 2) & nb(0)
goal(joueur 2, 0) :- control(joueur 1) & nb(0)


#Le monde des cubes :
#On a un état initial du problème qui consiste en une configuration des cubes sur la table.
#On souhaite arriver à un état final.
#Modéliser le problème pour 6 cubes que l'on souhaite empiler dans l'ordre et qui sont au départ tous isolés sur la table.

role(you)

init(sur(a, table))
init(sur(b, table))
init(sur(c, table))
init(sur(d, table))
init(sur(e, table))
init(sur(f, table))

init(libre(a))
init(libre(b))
init(libre(c))
init(libre(d))
init(libre(e))
init(libre(f))

legal(robot, move(X, table)) :- libre(X)
legal(robot, move(X, Y)) :- libre(X) & libre(Y)

next(sur(X, Y)) :- does(robot, move(X, Y))
next(sur(X, Y)) :- true(sur(X, Y)) & does(robot, move(Z, Z1)) & distinct(X, Z)

next(libre(X)) :- does(robot, move(Y, Z)) & true(libre(X)) & distinct(Z, X)
next(libre(X)) :- does(robot, move(Y, Z)) & true(sur(Y, X))

 goal(robot, 100) :- true(sur(a, table)) &
                        true(sur(b, a)) &
                        true(sur(c, b)) &
                        true(sur(d, c)) &
                        true(sur(e, d)) &
                        true(sur(f, e))

#Un appartement comporte un salon, une cuisine et un placart ces trois pièces sont reliées deux à deux.
#Un singe se trouve dans le salon et un régime de bananes est accroché au plafond de la cuisine.
#Une caisse est posée au sol dans le placard.
#Trouver une suite d'actions du singe affamé pour attraper les bananes sechant que pour atteindre son but il doit monter sur la caisse.

#Aller dans la placard
#Prendre la caisse
#Aller dans la cuisine avec la caisse
#Monter sur la caisse
#Attraper les bananes

#Ecrire la base de faits initiale sachant que le singe se nomme cheeta, la caisse ks et le régime de bananes split.
#Décrire le problème en GDL.

init(dans(cheeta, salon))
init(dans(ks, placard))
init(dans(split, cuisine))

move(salon, placard)
move(placard, salon)
move(salon, cuisine)
move(cuisine, salon)
move(placard, cuisine)
move(cuisine, placard)

legal(cheeta, aller(X)) :- true(dans(cheeta,Y)) & move(Y, X)
legal(cheeta, prend(ks)) :- true(dans(cheeta, X)) & true(dans(ks, X))
legal(cheeta, attrape(split)) :- true(prise(ks)) & true(dans(cheeta, X)) & true(dans(ks, X))

next(dans(cheeta, X)) :- does(cheeta, aller(X))
next(dans(cheeta, X)) :- true(dans(cheeta, X)) & not does(cheeta, aller(Y))
next(prise(ks)) :- does(cheeta, prend(ks))
next(prise(ks)) :- true(prend(ks))
next(manger(split)) :- does(cheeta, attrape(split))
next(dans(ks, placard)) :- not does(cheeta, prend(ks)) & true(dans(ks, placard))
next(dans(split, placard)) :- true(dans(split, cuisine)) & not does(cheeta, attrape(split))

goal(cheeta, 100) :- true(manger(split))