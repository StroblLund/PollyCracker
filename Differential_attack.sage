def encryptor(m,Q,num_hid=1,extra=3):
    """this one doesn't work yet """
    """Version such that num_hid number of monomials are hidden, each in num_hid number different public polynomials 
Qe are the polynomials which will contain a monomial which has to be deleted
Qs are the polynomials whith which the monimials from Qe are deleted
m_erase,m_erase_c is the monomial wich will be deleted
hs are the constructed  which are to be deleted
he are the monomials used for the deletation
he_r,he_r_c are polyonomials which are made to fill up h[i]

    """
    if len(Q)/2 < num_hid:
        print('Too many polynomials chosen')
        return
    test=0
    Qs=[Q.pop(randint(0,len(Q)-1)) for _ in range(num_hid)]
    Qe=[Q.pop(randint(0,len(Q)-1)) for _ in range(num_hid)]
    k,kcoeff=map(list,zip(*[random_p_new(a.degrees(),25,field,len(Qs)) for a in Qe]))
    rand_var=randint(0,len(k)-1)
    m_erase=[k[i].pop(rand_var) for i in range(len(Qe))]
    m_erase_c=[kcoeff[i].pop(rand_var) for i in range(len(Qe))]
    if test ==0:
        hs=[poly_constructor(m,m_c) for m,m_c in zip(m_erase,m_erase_c)]#hs are polynomials which gonna get erased
        he=[sum(mono_del(s,e,m,m_c)) for s,e,m,m_c in zip(Qs,Qe,m_erase,m_erase_c)] #he is a list with polynimials and corresponding to Qe
    hs_r,hs_r_c=random_p_new([0]*num_var,15,field,len(Qs)*extra)
    hs_temp=[poly_constructor(deg,coeff) for deg,coeff in zip(hs_r,hs_r_c) ]
    hs_temp=[sum(hs_temp[:len(Qs)]) for i in range(extra)]
    hsx=[a+b for a,b in zip(hs,hs_temp)]
    hsx=sum(hsx,randint(0,field))
    he_r,he_r_c=random_p_new([0]*num_var,15,field,len(Qe)*extra)
    he_temp=[poly_constructor(deg,coeff) for deg,coeff in zip(he_r,he_r_c) ]
    he_temp=[sum(he_temp[:len(Qe)],randint(0,field)) for _ in range(extra)]
    hen=[a+b for a,b in zip(he,he_temp)]
    h_temp=[sum([random_poly(field,degrees) for _ in range(randint(1,num_var))],randint(1,field)) for _ in range(len(Q))]
    Q=flatten([Qs,Qe,Q])
    H=flatten([hsx,hen,h_temp])
    c=sum([q*h for q,h in zip(Q,H)])+m
    return c,Q,H,hs

def recu(c,Q):
    "This runs the differential attack recursively on a given ciphertext"
    attack=differential_attack_new(Q,c)
    if attack[0] != True:
        cp=reducer(c,Q,attack)
        if cp.number_of_terms()==1:
            print('Message sent is:',latex(cp))
            return cp
        else:
            print('going strong',cp)
            return recu(cp,Q),


def reducer(c,Q,results):
    k=[]
    for pub,res in zip(Q,results):
        cps=[c-pub*b for b in res]
        k=k+cps
    l=[d.number_of_terms() for d in k]
    index=min(range(len(l)),key=l.__getitem__)
    print('reducer runs')
    return k[index]

def poly2list(poly):
    "makes polynomial to list, easier to handle monomials"
    polym=poly.monomials()
    polyc=poly.coefficients()
    return [i*j for i,j in zip(polym,polyc)]


def delta(q):
    "this calculates the delta"
    if q.number_of_terms()==1:
        return [],[]
    # print('started delta')
    ql=poly2list(q)
    l=[]
    x=[]
    for i in range(len(ql)):
       l=l+[ql[i]/k for k in ql[i:] if ql[i] !=k]
       x=x+[k for k in ql[i:] if ql[i] !=k]
    return l,x


def comparison(dc,dcx,dq,dqx):
    "this compares the lists, picks the elements that are equal and calculates the potential term t_h"
    print('started to compare')
    result=[]
    new_list = [c/q for c,dc in zip(dcx,dc) for q, dq1 in zip(dqx,dq) if dc == dq1]
    #for k in range(len(dc)):
    #    for h in range(len(dq)):
    #        if dc[k] == dq[h]:                #check equality
    #            result.append(dcx[k]/dqx[h])    #append potential term
    #print(new_list,result)
    return new_list



def lin_alg_checker(q,h,c):
    "checks if monomials in the secret polynomials are contained in the set"
    "{mc/mq | mc in M(c) and mq in M(q1) U M(q2) see A Differential Attack on Polly Cracker paper by Hofheinz Steinwandt"
    lq=[]
    lh=[]
    cm=c.monomials()
    qm=[a.monomials() for a in q]
    for a in qm:
        lq=lq+a
    lq=list(set(lq))
    hm=[b.monomials() for b in h]
    for a in hm:
        lh=lh+a
    lh=list(set(lh))
    Mset = [mc/mq for mc in cm for mq in lq]
    for mh in lh:
        if mh not in Mset:
            print(mh,'is not contained, \nhence Intelligent Linear Algebra attack doesnt work')
            return True
    print('No luck this time')
    return False

def differential_attack_new(q,c):
    dc,dcx=delta(c)
    dlists,dlists_coeff=[],[]
    for a in q:
        result,result_coeff=delta(a)
        dlists.append(result)
        dlists_coeff.append(result_coeff)
    test=set(dlists[0])
    for items in dlists:
        test=test.intersection(set(items))
    for l in test:
        for d in range(len(dlists)):
            index=dlists[d].index(l)
            dlists[d].pop(index)
            dlists_coeff[d].pop(index)
    dic_c=dict(zip(dc,dcx))
    dic_new=[dict(zip(a,b)) for a,b in zip(dlists,dlists_coeff)]
    dic_keys=[reduce(operator.__and__, map(set, [dic_c,dic_list])) for dic_list in dic_new]
    results=[[dic_c[k]/d2[k] for k in dic_c.keys() & d2] for d2 in dic_new]
    results=[list(set(d)) for d in results]
    if not any(results):
        print('Differential Attack doesn\'t work, rest of message is:',latex(c))
        return True,c
    else:
        #print('Possible hidden monimials are:',latex(results))
        return results

