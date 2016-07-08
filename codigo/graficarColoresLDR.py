import math
import numpy as np
import matplotlib.pyplot as plt
import pylab
import sys

#arr = np.genfromtxt("ldrasm")
#x = [row[0] for row in arr]


#arrr = np.genfromtxt("ldrc")

#w = [row[0] for row in arrr]

roja = 18854592 # ROJA

colors = 18923260 # Multi
negra = 18990810
blanca = 18859794
verde = 18904808
azul = 18951804

width = 0.5


p1 = plt.bar(1, roja, width, color='r', label = 18951804.000)
p2 = plt.bar(2, colors, width, color='y')
p3 = plt.bar(3, negra, width, color='black')
p4 = plt.bar(4, blanca, width, color = 'grey')
p5 = plt.bar(5, verde, width, color = 'green')
p6 = plt.bar(6, azul, width, color = 'blue')

plt.ylabel('Cantidad de ciclos de Clock')
plt.title('Low Dynamic Range')
plt.yscale('log', basey=4)
#plt.xticks(ind + width/2., ('Roja', 'Multicolor'))
#plt.yticks(np.arange(0, 81, 10))
plt.legend((p1, p2, p3, p4, p5, p6), ('roja', 'multicolor', 'negra', 'blanca', 'verde', 'azul'))

plt.show()
