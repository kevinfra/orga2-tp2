import math
import numpy as np
import matplotlib.pyplot as plt
import pylab
import sys

arr = np.genfromtxt("cropasm")
x = [row[0] for row in arr]
y = [row[1] for row in arr]


arrr = np.genfromtxt("cropc")

w = [row[0] for row in arrr]
z = [row[1] for row in arrr]



fig = plt.figure()
fig.patch.set_facecolor('white')
ax1 = fig.add_subplot(111)
pylab.plot(x,y,'r', label= 'Ensamblador')
pylab.plot(w,z,c='b', label = 'C')


ax1.set_title("Cropflip")    
ax1.set_xlabel('Cantidad de pixeles de la imagen')
ax1.set_ylabel('Cantidad de ciclos de Clock')
ax1.set_yscale('log', basey=4)
ax1.set_xscale('log', basex=4)

leg = ax1.legend()

leg = plt.legend( loc = 'upper left')

plt.show()
