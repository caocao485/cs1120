###
### ps6.py
###
### Add your answers and code to this file.
###

### Name(s):
###
### Email ID(s):
###

from adventure import *  # this brings everything in adventure.py into our namespace
from charlottansville import *

### Importing * like this is bad practice since it pollutes the namespace,
### but avoids the need to use module names.

### Question 1:

"""
You can use triple-quotes to start and end a multi-line comment in Python.
Use triple-quotes to enter your answers to questions that call for answers
other than code, such as your Python expressions for Question 1.
"""
1 + 1
(2 * 3) + (4 * 5)
def square(x):
    return x * x

square(2)

if 3 > 4:
    print(5)
else:
    print(6)



### Question 2:
thing = OwnableObject("book")
print(thing.is_ownable())

person = Person("Alyssa")
person.say("hello world!")

### Question 3:
class Professor(Lecturer):
    def profess(self,stuff):
        self.say("It is intuitively obvious that " + stuff + " - you should be taking notes")


### Question 4:
class Dean(Professor):
    def say(self,utterance):
        Professor.say(self, utterance + " - We need your help, please send money now.")
               
### Question 5:
class Student(Person):
    def __init__(self, name):
        Person.__init__(self,name)
        self.dressed= True
    def get_undressed(self):
        if self.dressed:
            self.dressed= False
            self.say("Brr! It's cold!")
        else:
            self.say("I have no more clothes to remove!")
    def get_dressed(self):
        if not self.dressed:
            self.dressed = True 
            self.say("I feel much better now.")
    def is_dressed(self):
        return self.dressed






class PoliceOfficer (Person):
    def __init__(self, name, jail):   ### keep this!
        Person.__init__(self, name)
        self.set_restlessness(0.5)
        self._jail = jail

    # Question 6: define the arrest method
    def arrest(self,person):
        if self.location == person.location:
            self.say(person.name + ", you are under arrest!")
            self.say("You have the right to remain silent, call methods, and mutate state.")
            person.move(self._jail)
        else:
            self.say(person.name + " is not here")


    # Question 7: define the tick method
    def tick(self):
        arrested_one = False 
        for thing in self.location.get_things():
            if isinstance(thing,Student) and not thing.is_dressed():
                if not arrested_one:
                    arrested_one = True   
                self.arrest(thing)
        if not arrested_one:
            self.say(" No one to arrest. Must find donuts.")
            Person.tick(self)

### Question 8:

"""
Describe your extension and answer the questions a-e about
it here or on a separate sheet.
"""

# code for your extension

class twitter(Lecturer):
    def lecture(self,stuff):
        print("hello world")


class facebook(Lecturer):
    def lecture(self,stuff):
        Lecturer.lecture(self,stuff+ " facebook are here!")

class zhihu(Lecturer):
    def tick(self):
        self.say("hello zhihu")

def sreverse(p):
    if len(p) == 1:
        return
    else:
        rest=p[1:]
        first=p[0]
        sreverse(rest)
        p[0] = rest[0]
        p[1:] = rest[1:]
        p.append(first)

def reversee(p):
    for i in range(0,len(p) >> 1):
        p[i],p[len(p) - 1 - i] = p[len(p) - 1 - i],p[i]

