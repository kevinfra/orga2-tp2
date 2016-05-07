# import matplotlib.pyplot as plt
# import numpy as np

# t = np.arange(0.0, 5.0, 0.01)
# s = np.sin(2*np.pi*t)


# def lineal(m,x1,x2,b):
#   for i in range(x1,x2):
#       y=m*i+b

#   return y
# a = np.arange(0.0, 5.0, 0.01)
# b = lineal(1,0,5,0)
# plt.plot(t, s)


# plt.plot(1,b)

# plt.xlabel('Las X amigo')
# plt.ylabel('Las Y amigo')
# plt.title('Grafican2')
# # plt.grid(True)
# plt.savefig("test.png")
# plt.show()



#def graphico(formula, x_range, formula2, x_range2):  
    # x = np.array(x_range)  
    # y = eval(formula)
    # w = np.array(x_range2)
    # z = eval(formula2)
    # a=5
    # hola.plot(3,a,'bo')
    # #plt.plot(x, y)  
    # a=30
    # plt.plot(2,2,'ro')
    # plt.plot(1,10,'go')
   # plt.show()
   # plt.plot(w, z)
# for i in range(1,10):
#       hola.plot(i,i,'go')
# plt.xlabel('Las X amigo')
# plt.ylabel('Las Y amigo')
# plt.title('Grafican2')
# plt.grid(True)
# plt.savefig("test.png")
# plt.show()


#graphico('2*x',range(0,5),'3*x',range(0,5))

#!/usr/bin/python



# with open("GG.txt") as f:
#     data = f.read()

# data = data.split('\n')

# x = [row.split(' ')[0] for row in data]
# y = [row.split(' ')[1] for row in data]

# fig = plt.figure()

# ax1 = fig.add_subplot(111)

# ax1.set_title("Plot title...")    
# ax1.set_xlabel('your x label..')
# ax1.set_ylabel('your y label...')

# ax1.plot(x,y, c='r', label='the data')

# leg = ax1.legend()

# plt.show()
import math
import numpy as np
import matplotlib.pyplot as plt
import pylab
import sys

arr = np.genfromtxt("sepiasm")
x = [row[0] for row in arr]
y = [row[1] for row in arr]

# arro3 = np.genfromtxt("SEPIALENTO")
# d = [row[0] for row in arro3]
# e = [row[1] for row in arro3]


arrr = np.genfromtxt("sepiac")

w = [row[0] for row in arrr]
z = [row[1] for row in arrr]


# a = np.arange(2048*2048)
# b = 600*a


fig = plt.figure()
fig.patch.set_facecolor('white')
ax1 = fig.add_subplot(111)
pylab.plot(x,y,'r', label= 'Ensamblador')
pylab.plot(w,z,'b', label = 'C')
#pylab.plot(d,e,c='r', label= 'Co3')

#pylab.plot((a),(b), c='r', label ='f(X)=1024x')
# plt.errorbar(w, z, np.std(desvio))
ax1.set_title("SEPIA")    
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
