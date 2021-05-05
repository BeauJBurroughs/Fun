#!/bin/python3

import time

Jokes = [
"""Two hunters are out in the woods when one of them collapses. He’s not breathing and his eyes are glazed. The other guy whips out his cell phone and calls 911.
"I think my friend is dead!” he yells. “What can I do?”
The operator says, “Calm down. First, let’s make sure he’s dead.”
There’s a silence, then a shot. Back on the phone, the guy says, “OK, now what?"
""",
"""
A turtle is crossing the road when he’s mugged by two snails. When the police show up, they ask him what happened. The shaken turtle replies, “I don’t know. It all happened so fast.” 
""",

"""What do you get a hunter for his birthday? A birthday pheasant""",

"""What does a clam do on his birthday? He shellabrates!""",

"""Why was the birthday cake as hard as a rock? Because it was marble cake!"""

]

def Telling_jokes():
    kaia = "not laughing"
    while kaia == "not laughing":
        for joke in Jokes:
            print(joke)
            time.sleep (1)
            print("are you laughing?(yes/y)")
            laughing = input()
            if laughing == "yes" or laughing =="y":
                kaia = "laughing"
                break
            else:
                kaia = "not laughing"
                continue
    return


Telling_jokes()
