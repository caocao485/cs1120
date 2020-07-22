# # adventure.py #

import random

# This procedure determines if the input obj provides a method named mname.
# It is not necessary to understand how this code works.
def has_method(obj, mname):
    try:
        if getattr(obj, mname):
            return True
    except AttributeError:
        return False            
    
class SimObject:
    def __init__(self, name):
        self.name = name

    def __str__(self):
        return "<simobject: " + self.name + ">"
    
    def is_ownable(self):
        return False # overridden by some subtypes

    def is_installed(self):
        return False # overridden by some subtypes

    def is_greetable(self):
        return False # overriden by objects that like to be greeted
    
    def note(self, msg):
        print ("%s: %s" % (self, msg))

class PhysicalObject (SimObject):
    def __init__(self, name):
        SimObject.__init__(self, name)
        self.location = False # not set until installed

    def is_installed(self):
        return self.location # if it has a location, is installed
    
    def install(self, loc):
        self.note ("Installing at " + str(loc))
        self.location = loc
        loc.add_thing(self)

class MobileObject (PhysicalObject):
    def change_location(self, loc):
        self.location.remove_thing(self)
        loc.add_thing(self)
        self.location = loc

# Physical objects have a location as well as a name

class OwnableObject (MobileObject):
    def __init__(self, name):
        MobileObject.__init__(self, name)
        self.owner = None # not owned

    def is_ownable(self): return True
    def is_owned(self): return self.owner

def direction_opposite(d):
    if d == 'north': return 'south'
    elif d == 'south': return 'north'
    elif d == 'east': return 'west'
    elif d == 'west': return 'east'
    elif d == 'enter': return 'exit'
    elif d == 'exit': return 'enter'
    else: raise Exception("Bad direction: " + d)

# Place

class Place (SimObject):
    def __init__(self, name):
        SimObject.__init__(self, name) 
        self._neighbors = {} # dictionary of direction -> place entries
        self._things = [] # list of SimObject
        
    def __str__(self):
        return "<place: " + self.name + ">"
   
    def is_place(self):
        return True

    def reset(self):
        self.note("Reset")
        self._neighbors = {}
        self._things = []

    def get_things(self):
        # Returns a copy of the __things list.
        #(not the list itself)
        return list(self._things)
        
    def has_thing (self, thing):
        return thing in self._things

    def add_thing(self, thing):
        self._things.append(thing)

    def remove_thing(self, thing):
        assert (thing in self._things)
        self._things.remove(thing)
    
    def get_neighbors(self):
        return self._neighbors.values()

    def get_exits(self):
        return self._neighbors.keys()

    def neighbor_towards(self, direction):
        if direction in self._neighbors:
            return self._neighbors[direction]
        else:
            return False # no neighbor in this direction
        
    def add_neighbor(self, direction, place):
        if self.neighbor_towards(direction):
            raise StandardError("Attempt to add duplicate neighbor to " + str(self) + ": " + str(place))
        self._neighbors[direction] = place
        
def list_to_string(p):
    if not p:
        return "nothing"
    msg = ""
    for el in p:
       msg = msg + str(el) + ", "
    msg = msg.rstrip(", ")# remove the last comma
    return msg
    
class Person (MobileObject):
    def __init__(self, name):
        MobileObject.__init__(self, name)
        self._possessions = [] # what person is crrying (initially empty)
        self._restlessness = 0.0 # propensity to move randomly

    def get_possessions(self):
        # return a copy, caller should not be able to modify __possessions
        return list(self._possessions) 
    
    def display_possessions(self):
        self.say ("I have " + list_to_string(self._possessions))

    def say(self, utterance):
        if self.is_installed ():
            print ("At " + self.location.name + ":",)
        print (self.name + " says -- " + utterance)

    def have_fit(self):
        self.say("Yaaaah! I am upset!")

    def look(self):
        if not self.is_installed():
            self.note("Cannot look until person is installed.")
            return
        
        # Don't see yourself, so remove it from things
        otherthings = self.location.get_things()
        otherthings.remove(self)
        otherthingnames = map(lambda t: t.name, otherthings)
        self.say("I see " + list_to_string(otherthingnames))
        self.say("I can go " + list_to_string(self.location.get_exits()))

    def take(self, thing):
        if not self.is_installed():
            self.note("Cannot take until person is installed.")
            return

        if thing in self._possessions:
            self.say ("I already have " + thing.name)
            return False
        elif thing in self.location.get_things():
            if thing.is_ownable():
                if thing.is_owned():
                    thing.owner.lose(thing)
                thing.owner = self
                self._possessions.append(thing)                
                self.say ("I take " + thing.name)
                return True
            else:
                self.say ("Cannot take " + thing.name)
                return False
        else:
            self.say ("There is no " + thing.name + " here")
            return False

    def lose(self, thing):
        assert self.is_installed()
        if thing.owner == self:
            assert thing in self._possessions
            self._possessions.remove(thing)
            self.say ("I lose " + str(thing))
            self.have_fit()
            return True
        else:
            self.say ("I cannot lose what I do not have, and I have no " + str(thing))
            return False

    def set_restlessness(self, value):
        self._restlessness = value

    def is_greetable(self): 
        return True
    
    def tick(self):
        if random.random() < self._restlessness:
            self.act_randomly()

    def act_randomly(self):
        exits = self.location.get_exits()
        if exits:
            randomexit = random.sample(exits, 1)[0]
            self.go(randomexit)

    def move(self, loc):
        if not self.is_installed():
            self.note("Cannot move until person is installed.")
            return

        assert isinstance(loc, Place)
        print (self.name + " moves from " + self.location.name + " to " + loc.name)
        self.change_location(loc)
        for thing in self._possessions:
            thing.change_location(loc)
        greetees = filter(lambda t: t.is_greetable(), loc.get_things())
        greetees.remove(self) # don't greet yourself!
        if greetees:
            map(lambda greetee: self.say("Hi " + greetee.name), greetees)
        else:
            self.say("Its lonely here...")

    def go(self, direct):
        if not self.is_installed():
            self.note("Cannot go until person is installed.")
            return

        newloc = self.location.neighbor_towards(direct)
        if newloc:
            return self.move(newloc)
        else:
            print ("You cannot go " + str(direct) + " from " + str(self.location))
            return False

class World:
    def __init__(self, n):
        self.name = n
        self._places = {} # to make lookups fast, we store the places in a dictionary indexed by name
        self._things = {} # and things in a dictionary indexed by name

    def __str__(self):
        return '<world: ' + self.name + '>'
    
    def add_place(self, p):
        if self.has_place (p.name):
            raise StandardError("Attempt to add place with duplicate name.")
        self._places[p.name] = p

    def has_place(self, name):
        return self._places.has_key(name)

    def get_place(self, name):
        if self.has_place(name):
            return self._places[name]
        else:
            return None

    def install_thing(self, t, pname):
        assert self.has_place(pname)
        if self.has_thing (t.name):
            raise StandardError("Attempt to add thing with duplicate name.")
        self._things[t.name] = t
        t.install(self.get_place(pname))

    def has_thing(self, name):
        return self._things.has_key(name)
    
    def get_thing(self, name):
        if self.has_thing(name):
            return self._things[name]
        else:
            return None
        
    def connect_one_way(self, pn1, d, pn2):
        assert self.has_place(pn1)       
        assert self.has_place(pn2)        

        place1 = self.get_place(pn1)
        place2 = self.get_place(pn2)
        
        place1.add_neighbor(d, place2)
        
    def connect_both_ways(self, pn1, d, pn2):
        # connects two places in direction d
        self.connect_one_way(pn1, d, pn2)
        self.connect_one_way(pn2, direction_opposite(d), pn1)

    def tick(self):
        # next time step for all objects that tick        
        for t in self._things:
            obj = self.get_thing(t)
            if has_method(obj, "tick"):
                obj.tick()                
        
    def play_interactively(self, character):        
        while True: # loop forever, getting new commands
            commands = raw_input("what next? ")
            if not commands:
                print ("Huh?")
            else:
                try:
                    advance = False # time only advances after certain actions    
                    cmdlist = commands.split() # separate commands
                    action = cmdlist[0]
                    if action == "quit":
                        print ("Better luck next time.  Play again soon!")
                        break;                           
                    elif action == "look":
                        character.look()
                        advance = True
                    elif action == "go":
                        if len(cmdlist) != 2:
                            print ("A go command must be followed by a direction.")
                            continue
                        else:
                            character.go(cmdlist[1])
                            advance = True
                    elif action == "take":
                        if len(cmdlist) != 2:
                            print ("A take command must be followed by the name of the item you want to take.")
                            continue
                        else:
                            character.take(self.get_thing(cmdlist[1]))
                            advance = True
                    elif action == "get":
                        if len(cmdlist) != 2:
                            print ("A get command must be followed by a second attribute.")
                        elif cmdlist[1] == "dressed":
                            character.get_dressed()
                            advance = True
                        elif cmdlist[1] == "undressed":
                            character.get_undressed()
                            advance = True
                        else:
                            print ("Sorry, I don't know how to get " + cmdlist[1])
                    else: 
                        print ("Sorry, I don't know how to " + str(action))
                except AttributeError, msg:
                   print ("Error: undefined method: " + str(msg))

                if advance:
                    self.tick()
                    
class Lecturer (Person):
    def lecture(self, stuff):
        self.say (stuff + " - you should be taking notes")




