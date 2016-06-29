import math
import numpy as np
import matplotlib.pyplot as plt
import pylab
import sys

# La que tiene arranca con G es GCC, Clang arranca con C
arr1 = np.genfromtxt("Gcropc")
a = [row[0] for row in arr1]
b = [row[1] for row in arr1]

arr2 = np.genfromtxt("Gsepiac")
c = [row[0] for row in arr2]
d = [row[1] for row in arr2]

arr3 = np.genfromtxt("Gldrc")
e = [row[0] for row in arr3]
f = [row[1] for row in arr3]

arr4 = np.genfromtxt("Ccropc")
g = [row[0] for row in arr4]
h = [row[1] for row in arr4]

arr5 = np.genfromtxt("Csepiac")
i = [row[0] for row in arr5]
j = [row[1] for row in arr5]

arr6 = np.genfromtxt("Cldrc")
k = [row[0] for row in arr6]
l = [row[1] for row in arr6]



fig = plt.figure()
fig.patch.set_facecolor('white')
ax1 = fig.add_subplot(111)
pylab.plot(a,b,'r', label= 'GCC-Crop')
pylab.plot(c,d,'g', label= 'GCC-Sepia')
pylab.plot(e,f,'b', label = 'GCC-LDR')
pylab.plot(g,h,'y', label = 'Clang-Crop')
pylab.plot(i,j,'black', label = 'Clang-Sepia')
pylab.plot(k,l,'purple', label = 'Clang-LDR')

#pylab.plot((a),(b), c='r', label ='f(X)=1024x')
# plt.errorbar(w, z, np.std(desvio))
ax1.set_title("GCC VS Clang,O0")    
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
