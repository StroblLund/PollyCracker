
def random_poly(coeff,degrees):
    deg=[randint(0,degrees[0]) for _ in range(len(degrees))]
    d=randint(1,coeff)
    poly=F({tuple(deg):d})
    return poly

def random_p(degrees,delta,k):
    "generates a random monomial in range degrees=(degx_have to beegx_1,degy_0,degy_1,degz_0,degz_1)"
    "where lower and upper range for degree have thave to bee given"
    degx,degy,degz = degrees
    degs=[randint(degx,degx+delta), randint(degy,degy+delta),randint(degz,degz+delta)]
    coeff=randint(0,k)
    return degs, [coeff]

def random_p_new(degrees,delta,k,number):
    "generates a random monomial in range degrees=(degx_have to beegx_1,degy_0,degy_1,degz_0,degz_1)"
    degs=[[randint(degrees[0]+delta,degrees[0]+2*delta) for _ in range(len(degrees))] for _ in range(number)]
    coeff=[randint(0,k)for _ in range(number)]
    return degs, coeff
def mono_div(polya,polyb):
    "divides two monomials, supplied as lists"
    return list(map(operator.sub, polya, polyb))

def mono_mul(polya,polyb):
    "multiplies two monomials, supplied as lists"
    return list(map(operator.add, polya,polyb))

def coeff_mul(coeffa,coeffb):
    "multiplies the coefficients of polynomials, supplied as lists"
    #return [q*b for q in coeffa for b in coeffb]
    return [q*b for q,b in zip(coeffa,coeffb)]


def coeff_div(coeffa,coeffb):
    "divides the coefficients of polynomials, supplied as lists"
    return [q/b for q,b in zip(coeffa,coeffb)]


def poly_constructor(deg,const):
    return F({(tuple(deg)):const})

def poly2list(poly):
    "makes polynomial to list, easier to handle monomials"
    polym=poly.monomials()
    polyc=poly.coefficients()
    return [i*j for i,j in zip(polym,polyc)]


def list_maker(poly):
    """makes two lists from a given sum of polynomials, returns a list with degrees and one
    with coressponding coefficients"""
    poly_dict=poly.dict()
    poly_list=[[list(k),v] for k,v in poly_dict.items()]
    coeff_list=[poly_list[i][1] for i in range(len(poly_list))]
    poly_list=[poly_list[i][0] for i in range(len(poly_list))]
    return poly_list,coeff_list



def mono_del(q1,q2,mx,mxC):
    """Takes in Q1,Q2 as lists and the monomial which should be hidden as degree mx and constant mxC
    returns a list with which Q2 needs to be multiplied such that the hidden monomial gets deleted in Q1"""
    q2=q2-q2.constant_coefficient()
    Q1,Q1c=list_maker(q1)
    Q2,Q2c=list_maker(q2)
    Q1mx=[mono_mul(q,mx) for q in Q1]
    Q1mxC = [mxC*k for k in Q1c]
    pairs=zip(Q1mx,Q2) if len(Q2)>len(Q1mx) else zip(Q1mx,cycle(Q2))
    pairs_c=zip(Q1mxC,Q2c) if len(Q2c)>len(Q1mxC) else zip(Q1mxC,cycle(Q2c))
    sol=[mono_div(k,Q2m) for k,Q2m, in pairs]
    sol_c=[q/b for q,b in pairs_c]
    coeffs=[-x for x in sol_c]
    res=[poly_constructor(sol,coeffs) for sol,coeffs in zip(sol,coeffs)]
    return res
