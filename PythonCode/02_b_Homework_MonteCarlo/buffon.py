import random as rnd
import math

class Neeedle:                  #Needle class embendeds all information for describing a needle 
    def __init__(self):
        self.extreme_1 = 0
        self.extreme_2 = 0
        self.angle = 0

    

    def throw(self):            
        self.extreme_1 = rnd.uniform(0,1)                       #extreme_1 random between [0,1]
        self.angle = rnd.uniform(-1,1)*math.pi                  #angle random  [pi, -pi]
        self.extreme_2= self.extreme_1+math.sin(self.angle)     #compute extreme_2 
    
    def intersect(self):                                        #bool function for the intersection
        if self.extreme_2<=0 or self.extreme_2>=1:
           # print("intersect")
            return True
            
        else:
            #print("not intersect")
            return False

count=0
N=10000

a=Neeedle()
for i in range(N):
    a.throw()                       #throwing N times the needle
    if a.intersect()==True:         
        count=count+1               #count how many time we had the intersection


print(count/N)