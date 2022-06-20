from random import randint
from operator import add,sub
from itertools import cycle
load('monomial_eraser.sage')
load('Differential_attack.sage')
load('binomials_creator.sage')
fields=[11166643,12116604131,912116606831]
num_vars=[5,10,20,30,50]
num_hides=[1,2,4,6]
pubpoly_nums=[5,10,15]


message=226


pubpoly_num=10

Final_c=[]
Final_H=[]
Final_Q=[]
field=fields[0]
num_var=num_vars[1]
num_h1=4
num_hide=2
degrees=num_var*[12]
settings=[num_var,field]
F=PolynomialRing(GF(field),x,num_var, order='degrevlex')

def experiments(message,runs):
    while len(Final_c) <runs:
        zero=tuple([randint(0,field) for _ in range(num_var-1)])+(0,)
        public_Q=creator(50,3,degrees,zero,field,False)
        Qb=[random_poly(randint(1,field),degrees)+random_poly(randint(1,field),degrees)]
        Qc=[random_q_pop(public_Q,randint(1,3),randint(1,5)) for _ in range(pubpoly_num-1)]
        Q=[*Qc,*Qb]
        c,Q,H,mh=encryptor(message,Q,1,1)
        works = lin_alg_checker(Q,H,c)
        if works==True:
            Final_c.append(c)
            Final_H.append(H)
            Final_Q.append(Q)
            save(Final_c,'c')
            save(settings,'settings')
            save(Final_Q,'Q')
            save(Final_H,"H")
        print(len(Final_c))


e=[experiments(226,10) for field in fields for num_var in num_vars]
