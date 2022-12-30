import random as np

N=30                        #number of people in the room
iterations=1000             #number of iterations


pr=[]


for l in range(iterations):
    date=[]
    for x in range(N):                           #generate N numbers between 1 and 365
        date.append(np.randrange(1,365))
    date.sort()                                  #sort the date vector
    
    no_copy=[]
    for i in date:                               #array with all the birthdays without copy
        if i not in no_copy:                     #(i.e. date=[.,12,12,35,.]--->no_copy[.,12,35,.]
            no_copy.append(i)
    
    count=[]
    for k in no_copy:                            #count contain the ripetition of the same birthday
        count.append(date.count(k))              #(i.e. date=[.,12,12,35,.]--->no_copy[.,12,35,.]
                                                 #--->count=[.,2,1,.])

    a=0
    for j in count:                              #check if at least there is a number inside count !=1
        if j!=1:                                 #yes->a=1 No->a=0
            a=1                                  #not really efficient, we should stop the loop 
            
        

    pr.append(a)
    

prob=sum(pr)/iterations                          #compute the probability
print(prob)
