#
# charlottansville.py
#

from adventure import * 
import ps6
   
def setup_Cville():
    cville = World("Charlottansville")

    # Add some of our favorite places to Charlottansville
    cville.add_place(Place('Noodles Hall'))      # Known for the best views in Charlottansville
    cville.add_place(Place("Witten's Noodles"))  # In Noodles Hall, known for their super-stringy spaghetti specials
    cville.add_place(Place('Sture G. Hall'))     # Sture is not related to Ali
    cville.add_place(Place('Cabal Hall'))        # Where conspirators scheme
    cville.add_place(Place('South Green'))       # Emerging terraces
    cville.add_place(Place('Bart Statue'))       # Son of Homer
    cville.add_place(Place('The Green'))         # World famous lawn
    cville.add_place(Place('U Haul'))            # Rumored to have ghosts of blue devils
    cville.add_place(Place('The Recursa'))       # Hub of all knowledge and honor
    cville.add_place(Place('Lambda Dome'))       # Dome of infinite wisdom and ultimate power
    cville.add_place(Place('University Ave'))    # Its just a street
    cville.add_place(Place('Cdrs Hill'))         # Home of the Head Transient
    cville.add_place(Place('Cricket Street'))    # Known for its sticky wickets
    cville.add_place(Place('Dumplings Truck'))   # Charlottansville's finest dining establishment
    cville.add_place(Place('Oldbrushe Hall'))    # Charlottansville's not-so-finest dining establishment
    cville.add_place(Place('Old Dorms'))         # Students live here
    cville.add_place(Place('New Dorms'))         # Students live here
    cville.add_place(Place('Cloakner Stadium'))  # Sometimes misprounounced "Clockner", but the o: is like in Go:del
    cville.add_place(Place('Somdergal Library')) # Named for the University's first president
    cville.add_place(Place('Jail'))              # Where students caught streaking are sent

    cville.connect_both_ways('The Green', 'south', 'Bart Statue')
    cville.connect_both_ways('Bart Statue', 'south', 'Cabal Hall')
    cville.connect_both_ways('Cabal Hall', 'south', 'South Green')

    cville.connect_both_ways('The Green', 'north', 'The Recursa')
    cville.connect_both_ways('The Recursa', 'north', 'University Ave')    
    cville.connect_both_ways('University Ave', 'north', 'Cdrs Hill')
    cville.connect_both_ways('Cdrs Hill', 'north', 'Cricket Street')
    cville.connect_both_ways('Cricket Street', 'north', 'U Haul')
    cville.connect_both_ways('U Haul', 'west', 'Cloakner Stadium')
                             
    cville.connect_both_ways('The Green', 'west', 'Somdergal Library')
    cville.connect_both_ways('Somdergal Library', 'west', 'Oldbrushe Hall')
    cville.connect_both_ways('Oldbrushe Hall', 'west', 'Old Dorms')
    cville.connect_both_ways('Old Dorms', 'west', 'New Dorms')
    
    cville.connect_both_ways('Oldbrushe Hall', 'south', 'Dumplings Truck')
    cville.connect_both_ways('Dumplings Truck', 'south', 'Sture G. Hall')
    cville.connect_one_way('Noodles Hall', 'secret passage', 'Sture G. Hall') # Noodles and Sture G. are connected through a secret basement passage
    cville.connect_one_way('Sture G. Hall', 'secret passage', 'Noodles Hall') # Noodles and Sture G. are connected through a secret basement passage
    cville.connect_both_ways('Noodles Hall', 'enter', "Witten's Noodles") # Witten's Noodles is inside Noodles Hall

    cville.connect_one_way('The Recursa', 'enter', 'Lambda Dome') # you can check in, but you can never leave
    cville.connect_both_ways('Lambda Dome', 'south', 'Lambda Dome')
    cville.connect_both_ways('Lambda Dome', 'east', 'Lambda Dome')

    return cville

def play_game_JT():
    cville = setup_Cville()
    cville.install_thing(Person('Evan Davis'), 'Cabal Hall')
    cville.install_thing(Person('Officer Krispy'), 'The Green')
    JT = Person('Jeffus Thomasson')
    cville.install_thing(JT, 'Cdrs Hill')
    cville.play_interactively(JT)

def play_game_as_APH():
    cville = setup_Cville()

    # this only works after you have defined the Student and PoliceOfficer classes
    aph = ps6.Student('Alyssa P. Hacker')
    ben = ps6.Student('Ben Bitdiddle')
    ben.set_restlessness(0.333)
    krumpke = ps6.PoliceOfficer('Officer Krumpke', cville.get_place('Jail'))
    cville.install_thing(aph, 'The Green')    
    cville.install_thing(ben, 'Cdrs Hill')
    cville.install_thing(krumpke, 'Bart Statue')
    cville.install_thing(OwnableObject('frisbee'), 'The Green')
    cville.play_interactively(aph)                            

def play_game_as_Krumpke():
    cville = setup_Cville()

    # this only works after you have defined the Student and PoliceOfficer classes
    aph = ps6.Student('Alyssa P. Hacker')
    aph.set_restlessness(0.5)
    ben = ps6.Student('Ben Bitdiddle')
    ben.set_restlessness(0.333)
    krumpke = ps6.PoliceOfficer('Officer Krumpke', cville.get_place('Jail'))
    krumpke.set_restlessness(0)
    cville.install_thing(aph, 'The Green')    
    cville.install_thing(ben, 'Cdrs Hill')
    cville.install_thing(krumpke, 'Bart Statue')
    cville.play_interactively(krumpke)          
