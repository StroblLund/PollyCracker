
def example_creator(num_poly,degree,zero,const=True):
    "Feed in: Number of binomials, maximal degree for each"
    "returns binomial in the form x^a*y^b*z^c+d if const==True"
    "otherwise arbitraty binomial"
    #deg1,deg2,deg3=degree
    #r0=[[randint(0,deg1), randint(0,deg2),randint(0,deg3)] for _ in range(num_poly)]
    r0=[[randint(0,degree[0]) for _ in range(len(degree))] for _ in range(num_poly)]
    #r0=[[randint(0,deg) for _ in range(num_var)] for _ in range(num_poly)]
    if const==True:
        r1=[num_var*[0] for _ in range(num_poly)] #sets
    else:
        r1=[[randint(0,degree[0]) for _ in range(len(degree))] for _ in range(num_poly)]
    poly0 = [poly_constructor(r0,1) for r0 in r0]
    poly1 = [poly_constructor(r1,1) for r1 in r1]
    solutions=matrix_constructor(poly1,poly0,zero)
    polys=[poly_constructor(deg,con) for deg,con in zip(r1,solutions)]
    final= [a-b for a,b in zip(polys,poly0)]
    return final


def creator(num_poly,num_terms,degree,zero,field,const=True):
    #l0=[[randint(0,degree[0]) for _ in range(len(degree))] for _ in range(num_poly*num_terms)]
    #l1=[[randint(0,degree[0]) for _ in range(len(degree))] for _ in range(randint(3,15))]
    #poly0 = [poly_constructor(r0,1) for r0 in r0]
    poly0=[random_poly(2,degree)]
    poly0= [random_poly(1,degree) for _ in range(num_poly*num_terms)]
    polys=[sum([poly0.pop() for _ in range(num_terms)]) for _ in range(num_poly)]
    polys_c=[polys(zero) for polys in polys]
    polys_end=[polys-polys_c for polys,polys_c in zip(polys,polys_c)]
    return polys_end


def random_q_pop(binomials,powers,num_terms):
    Q= sum([binomials.pop(randint(0,len(binomials)-1))**(randint(1,powers)) for _ in range(num_terms)])
    return Q
def random_q(binomials,powers,num_terms):
    "generates the public polynomials Q1 with a constant term, needs list of binomials"
    #Constant=False
    #while Constant == False:
        #Q = binomials[randint(1,len(binomials)-1)]**(randint(0,powers))+binomials[randint(1,len(binomials)-1)]**(randint(0,powers))+binomials[randint(1,len(binomials)-1)]**(randint(0,powers))
    Q= sum([binomials[randint(0,len(binomials)-1)]**(randint(1,powers)) for _ in range(num_terms)])
        #if Q.monomial_coefficient(x^0) !=0 and Q.number_of_terms()!=0:
            #Constant=True
    return Q

def matrix_constructor(poly0,poly1,zero):
    "receives two lists with polynomials to create a binomial expression and the common zero"
    "returns a list of constants solving Ab=X, not possible otherwise, due to sage bugs in solve_mod"
    A=diagonal_matrix([m(zero) for m in poly0],sparse=False)
    b=vector([n(zero) for n in poly1])
    loes=A.solve_right(b)
    return loes
