def rowGoldStars(g):
 for i in range(0, g):
    print("*x")
 print # (end the row by printing a new line)

def goldStarsSquare(g):
 for i in range(0, g):
    rowGoldStars(g) 


def listNegate(lst):
    for i,pos in zip(lst,range(0,len(lst))):
        lst[pos] = -i
