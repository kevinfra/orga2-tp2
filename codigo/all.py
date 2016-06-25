import math
import numpy as np
import matplotlib.pyplot as plt
import pylab
import sys

arr1 = np.genfromtxt("cropc")
x = [row[0] for row in arr1]
y = [row[1] for row in arr1]

arr2 = np.genfromtxt("sepiac")
d = [row[0] for row in arr2]
e = [row[1] for row in arr2]


arr3 = np.genfromtxt("ldrc")

w = [row[0] for row in arr3]
z = [row[1] for row in arr3]


fig = plt.figure()
fig.patch.set_facecolor('white')
ax1 = fig.add_subplot(111)
pylab.plot(x,y,'r', label= 'Cropflip')
pylab.plot(d,e,'g', label= 'Sepia')
pylab.plot(w,z,'b', label = 'LDR')

#pylab.plot((a),(b), c='r', label ='f(X)=1024x')
# plt.errorbar(w, z, np.std(desvio))
ax1.set_title("Clang con O3")    
ax1.set_xlabel('Cantidad de pixeles de la imagen')
ax1.set_ylabel('Cantidad de ciclos de Clock')
ax1.set_yscale('log', basey=4)
ax1.set_xscale('log', basex=4)


#ax1.plot(np.log2(x),np.log2(y), c='r', label='EL CHACHO ARRIBAS')
# pylab.plot((x),(y), c='r', label='ASM')
# pylab.plot(w,z, c='b',label='C')
leg = ax1.legend()

leg = plt.legend( loc = 'upper left')

plt.show()
