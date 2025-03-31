""" 1. Escriviu un programa (pot ser o no una funcio, com vulgueu) que
imprimeixi les lletres parells duna paraula, es a dir la 2a lletra, la 4a lletra, la 6a
lletra etc."""

#paraula = "bicicilisi"

#for i in range(1, (len(paraula)+1), 2):  #he empezado el for i in range en la letra b para que el output sean solo i
#    print(paraula[i]) 


""" 2. Feu una FUNCIÓ que compti els dígits d’una paraula o frase. Haurà
de tenir la següent signatura:​
​
compta_digits(cadena) i haurà de retornar el número de dígits.​
​
Si la frase és “Hola567” → ens retornarà 3; “sd45h j78k l9” ens retornarà 5"""


#def compta_digits(cadena):
#    contador = 0
#    for caracter in cadena:
#        if caracter.isdigit():
#            contador = contador + 1
#    return contador

#print(compta_digits("Hola567"))  
#print(compta_digits("sd45h j78k l9")) 

""" 4. Feu un programa o funció, que donada una frase d’entrada, ens retorni
la mateixa frase, però amb signes d’exclamació després de cada paraula.​
​
Per exemple, si la frase és “Hola com estàs?” ens retornarà “Hola! com! estàs?!”​"""

frase = input("pon una frase: ")
trozeada = frase.split()
for p in trozeada:
    print(p + "!")

