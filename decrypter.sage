from random import randint
from operator import add,sub
from itertools import cycle
load('monomial_eraser.sage')
load('Differential_attack.sage')
load('binomials_creator.sage')
settings=load('settings.sobj')
num_var,field=settings
L=LaurentPolynomialRing(GF(field),x,num_var, order='degrevlex')
C=load('c.sobj')
Q=load("Q.sobj")
H=load("H.sobj")
C=[L(a) for a in C] 
Q=[[L(a) for a in b] for b in Q]
#C=C[5:]
#Q=Q[5:]

print(recu(C[4],Q[4]))

#e=[recu(l,Q) for l,Q in zip(C,Q)]
#save(e,'e')


