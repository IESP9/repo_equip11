######################################################################################
# EXERCICIS DE STRINGS - Exercicis per entregar - SOLUCIÓ
######################################################################################

######################################################################################
# 1-. Feu un bucle que ens imprimeixi una paraula al revés. En aquesta primera versió,
# feu-ho fent servir un FOR (NO podeu fer servir indexos negatius!).

paraula = "hola"

for i in range(len(paraula)-1, -1, -1):     # -1 perque no arribarà a len! /
    print(paraula[i])                       # -1 perque baixi fins el 0 / -1 el pas

######################################################################################
# 2-. Feu el mateix, imprimir una paraula al revés, fent servir un while (NO podeu fer
# servir indexos negatius!).

i = len(paraula) -1     # index pel que volem començar a imprimir

while i >= 0:           # mentre no arribem a 0, però 0 inclòs
    print(paraula[i])
    i = i - 1           # baixem l'index per no entrar en un bucle infinit i
                        # avançar cap a l'inici de la paraula

######################################################################################
# 3-. Ara feu el mateix fent servir índexos negatius.

# anirem des de -1 (index de la ultima lletra), fins a -len (per tant el sostre al que
# no arriba és -len -1; i el pas que fem és -1

for i in range(-1, -len(paraula)-1, -1):
    print(paraula[i])

######################################################################################
# 4-. Sabrieu fer el mateix, però que el resultat quedés així? (aloH)(heu fet servir
# coses similars per solucionar exercicis de temes anteriors):

# Això ho haviem fet en algun dels primers exercicis. Enlloc d'imprimir els caràcters,
# simplement els acumulem a una variable

paraula_reverse = ""

for i in range(len(paraula)-1, -1, -1):
    paraula_reverse = paraula_reverse + paraula[i]

print(paraula_reverse)

######################################################################################
# 5-. Feu un programa o funció que si entrem un nom o una cadena de caràcters amb més
# d'una paraula, ens en retorna les incials, és a dir, la primera lletra de cada paraula.

nom = "Andreu Martin Pastor"

paraules = nom.split()  # partim el nom en paraules. Com que no li diem res, ho farà pels espais

for p in paraules:
    print(p[0])         # Per cada una de les paraules, imprimim el primer caràcter p[0]

######################################################################################
# 6-.Feu una funció que ens digui si una paraula és o no un PALÍNDROM. Un palíndrom és una
# paraula que és capicua, és a dir, que es llegeix igual de dreta a esquerra que d'esquerra a
# dreta.

def es_palindrom1(paraula):
    i = 0                   # index del principi
    j = len(paraula) - 1    # index del final

    while paraula[i] == paraula[j] and i < j:       # si no son iguals, o ja s'han creuat
        i = i + 1                                   # els indexs, podem parar
        j = j - 1               # si són iguals, simplement movem els indexs o 'dits'

    if i>=j:
        return True
    else:
        return False

def es_palindrom2(paraula):     # versio 2 amb un for, i l'index del final el fem en funcio de l'inicial
    for i in range(len(paraula)):
        if paraula[i] != paraula[len(paraula) -1 -i]:
            return False
    return True

######################################################################################
# 7-. Fes ara una funció que ens digui si una cadena és un palíndrom, però en aquest cas
# volem acceptar frases senceres, i ignorar els espais o les majúscules. Per tant podriem
# veure que "Dabale arroz a la zorra el abad" és un palíndrom. (Podeu ignorar els accents
# -"dábale" n'hauria de portar-).

def es_palindrom_frase(frase_majuscules):

    frase = frase_majuscules.lower()    # Nou -> posem la frase en minuscules!
    i = 0                 # index principi
    j = len(frase) - 1    # index final

    while frase[i] == frase[j] and i < j:
        i = i + 1
        j = j - 1
        # Nou -> mirem si hi ha espais i ens els saltem -suposem que només hi haurà UN espai
        if frase[i] == " ":
            i = i + 1
        if frase[j] == " ":
            j = j - 1

    if i>=j:
        return True
    else:
        return False

######################################################################################
# 8-. TECLAT DEFECTUÓS. Tenim una teclat molt dolent en que les tecles 's'enganxen'. Així,
# quan intentem escriure un text senzill ens passa això: "Holaaaaa eeeemmm diiiiccc Joaaaaaan"

def elimina_repetits(frase):    # versió senzilla NO considerem errors, com "accent"
    frase_nova = ""             # (perquè no mirarem un diccionari!)
    i = 0

    while i < len(frase) - 1:
        if frase[i] != frase[i+1]:              # si el caràcter és diferent al següent, el copio
            frase_nova = frase_nova + frase[i]  # sino no faig RES. No copiaré fins trobar-ne un diferent
        i = i + 1
    return frase_nova

######################################################################################
# 9-. Feu un programa o funció -com volgueu- que comprimeixi un text de la següent manera:
# Quan un caràcter apareix MÉS DE TRES vegades, el substituim per la cadena @n@c
# (on n és el número de vegades que ha aparegut el caràcter i c és el caràcter en si.

def comprimeix(cadena):
    anterior = cadena[0]
    i = 1
    comprimida = ""
    cont = 1
    while i < len(cadena):
        if cadena[i] != anterior:
            if cont == 1:
                comprimida = comprimida + anterior
            else:
                comprimida = comprimida + "@" + str(cont) + "@" + anterior
            anterior = cadena[i]
            cont = 1
        else:
            cont = cont + 1
        i = i + 1

    if cont == 1:
        comprimida = comprimida + anterior
    else:
        comprimida = comprimida + "@" + str(cont) + "@" + anterior

    return comprimida

######################################################################################
# 10-. Ara feu un programa (o funció) que descomprimeixi un text comprimit de la manera de
# l'exercici anterior.

def descomprimeix(cadena):
    i = 0
    descomprimida = ""
    while i < len(cadena):
        if cadena[i] != "@":
            descomprimida = descomprimida + cadena[i]
        else:
            i = i + 1
            num_str = ""
            while cadena[i] != "@":
                num_str = num_str + cadena[i]
                i = i + 1
            num = int(num_str)
            i = i + 1
            descomprimida = descomprimida + cadena[i] * num
        i = i + 1

    return descomprimida

frase = "Holaaaaa cccccoooommm essssstaaaaaas"
print(frase)
comprimida = comprimeix(frase)
print(comprimida)
print(descomprimeix(comprimida))

######################################################################################
# 11-. XIFRATGE DEL CESAR

def xifratge_cesar(text, clau):
    xifrat = ""
    abc = "abcdefghijklmnopqrstuvwxyz"

    for c in text:
        index = abc.index(c)
        xifrat = xifrat + abc[(index + clau) % len(abc)]  # Es podria fer en una linia, pero NO CAL!

    return xifrat

def cesar(text, clau, mode):
    if mode == "d":
        clau = -clau

    return xifratge_cesar(text, clau)

print(cesar("cdef", 2, "d"))