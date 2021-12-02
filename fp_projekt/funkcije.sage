#!/usr/bin/env python
# coding: utf-8

# # PROJEKT PRI FINANČNEM PRAKTIKUMU
# Najprej izberemo število točk $n = 3k$ za $k$ iz naravnih števil. Nato naključno generiramo te točke in jih zapišemo v slovar $p$.
# Ključi slovarja so števila od 0 do $n-1$, vrednosti pa $x$ in $y$ koordinate točk.
# 

# In[1]:


# za merjenje časa, ki ga porabi program potrebujemo uvoziti:
import time

#izberemo število točk
#n = 15
#
#if n <= 0:
#    print("Napaka: število točk mora biti pozitivno")
#elif n % 3 != 0:
#    print("Napaka: izbrati je treba 3k število točk za k iz naravnih števil")
#else:
#    print("Uspešno izbrano število točk")

    
# Naključno generiramo n točk v kvadratu (0,1)x(0,1) in jih shranimo v slovar
def generiraj_tocke(n):
    p = {i: (random(), random()) for i in range(n)}

    # Nato definiramo matriko M v katero bomo zapisali vse razdalje med točkami.
    M = matrix(RR,n)

    # Sledeča zanka v matriko M zapiše razdalje 
    for i in range(n):
        for j in range(n):
            M[i,j] = (((p[i][0])-(p[j][0]))^2 + ((p[i][1])-(p[j][1]))^2)^((0.5))

    return (p, M)
        
# Naprej nas zanima ali se dve povezavi med seboj sekata. V ta namen definiramo funkcijo 'seka', ki nam 
# pove ali daljica ij seka daljico lk, kjer so i,j,k,l števila med 0 in n-1.       
def zasuk(a,b,c):
    A = matrix(RR,3)
    A[0] = (1, *a)
    A[1] = (1, *b)
    A[2] = (1, *c)
    return(det(A))

def seka(a,b,c,d):
    if zasuk(a,b,c)*zasuk(a,b,d)<0 and zasuk(a,c,d)*zasuk(b,c,d)<0:
        return(1)
    else:
        return(0)


# ## Maksimizacija vsote robov
# Definiramo celoštevilski linearni program, ki maksimira vsoto dolžin vseh povezav, ki jih bomo uporabili.

# In[2]:

def max_vsota(p, M):
    n = len(p)
    start = time.time()

    clp = MixedIntegerLinearProgram(maximization=True)

    # Definiramo spremenljivko x, ki zavzame vrednost 0 ali 1
    x = clp.new_variable(binary=True)

    # Dodamo pogoje, ki jih je potrebno upoštevati v našem programu:

    #  1) Iz vsake točke lahko gresta natanko 2 povezavi, ali pa vanjo pride natanko 1 povezava.
    for i in range(n):
        clp.add_constraint(sum(x[i, j] + 2*x[j, i] for j in range(n)) == 2)
        
    #  2) Če se dve povezavi sekata, je lahko uporabljena zgolj ena izmed niju.
    for i in range(n):
        for j in range(n):
            for k in range(n):
                for l in range(n):
                    clp.add_constraint(x[i,j]+x[j,i]+x[k,l]+x[l,k]+seka(*(p[h] for h in (i,j,k,l)))<=2)
                    
                    
    # Dodamo cilj našega programa. V našem primeru maksimum vsote uporabljenih povezav.
    clp.set_objective(sum(x[i, j]*M[i,j] for i in range(n) for j in range(n)))

    # Izračunamo vrednost vsote.
    vsota = clp.solve()
    print(f'Vsota povezav je {vsota}')

    end = time.time()
    cas = end - start
    print(f"Program porabi {cas}")


    # In[3]:


    # Pogledamo katere povezave smo uporabili.
    povezave = clp.get_values(x)
    povezave1 = [k for k, v in povezave.items() if v == 1]
    #povezave1.keys()


    # In[4]:


    # Narišemo graf, ki prikazuje izbrane točke in povezave.
    G = Graph([[0..n-1], [e for e, v in clp.get_values(x).items() if v == 1]])
    G._pos = p
    #G.plot()

    return (vsota, cas, povezave1, G)


# # Maksimizacija najkrajšega roba
# V tem primeru bomo povezave izbrali tako, da bomo maksimirali dolžino najkrajše izbrane povezave.

# In[5]:

def max_min_povezava(p, M):
    n = len(p)
    start2 = time.time()

    clp2 = MixedIntegerLinearProgram(maximization=True)

    # Definiramo spremenljivko y, ki zavzame vrednost 0 ali 1
    y = clp2.new_variable(binary=True)

    # Definiramo realno nenegativno spremenljivko w
    w = clp2.new_variable(real=True, nonnegative=True)

    # Definiramo spremenljivko Mmax, ki je najdaljša možna povezave med izbranimi točkami
    Mmax = max(M[i,j] for i in range(n) for j in range(n))

    # Dodamo pogoje, ki jih je potrebno upoštevati v našem programu:

    #  1) Iz vsake točke lahko gresta natanko 2 povezavi, ali pa vanjo pride natanko 1 povezava.
    for i in range(n):
        clp2.add_constraint(sum(y[i, j] + 2*y[j, i] for j in range(n)) == 2)
        
    #  2) Če se dve povezavi sekata, je lahko uporabljena zgolj ena izmed niju.
    for i in range(n):
        for j in range(n):
            for k in range(n):
                for l in range(n):
                    clp2.add_constraint(y[i,j]+y[j,i]+y[k,l]+y[l,k]+seka(*(p[h] for h in (i,j,k,l)))<=2)
                    
    #  3) Spremenljivka w bo vedno manjša ali enaka najkrajši povezavi, ki jo bomo uporabili (za katero je y[i,j] == 1).
    for i in range(n):
        for j in range(n):
            clp2.add_constraint(w[1] <= M[i, j] + (1 - y[i, j]) * Mmax)
            
    # Kot cilj maksimiramo velikost w, kar maksimira dolžino najkrajše uporabljene povezave.
    clp2.set_objective(w[1])

    # Dobimo dolžino najkrajše uporabljene povezave.
    dolzina2 = clp2.solve()
    print(f'Dolžina najkrajše uporabljene povezave je {dolzina2}')

    end2 = time.time()
    cas2 = end2-start2
    print(f"Program porabi {cas2}")


    # In[6]:


    # Pogledamo katere povezave smo uporabili.
    povezave2 = clp2.get_values(y)
    povezave3 = [k for k, v in povezave2.items() if v == 1]
    #povezave3.keys()


    # In[7]:


    # Narišemo graf, ki prikazuje izbrane točke in povezave.
    G2 = Graph([[0..n-1], [e for e, v in clp2.get_values(y).items() if v == 1]])
    G2._pos = p
    #G2.plot()

    return (dolzina2, cas2, povezave3, G2)

def pozeni(n):
    print(f"Poganjam pri n = {n}")
    p, M = generiraj_tocke(n)
    v1, c1, p1, G1 = max_vsota(p, M)
    v2, c2, p2, G2 = max_min_povezava(p, M)
    return ((p, [list(map(float, r)) for r in M]), (v1, c1, p1, G1.sparse6_string()), (v1, c1, p1, G2.sparse6_string()))
