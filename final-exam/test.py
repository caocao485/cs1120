def collatz(n):
    if n == 1:
        return [1]
    else:
        vn = [n]
        if (n % 2) == 0:
            return vn + collatz(n/2)
        else:
            return vn + collatz(n*3 + 1)


def isMagicSquare(s):
 target = 0
 for e in s[0]:
    target = target + e
 diagsum = 0
 revdiagsum = 0
 for i in range(0, len(s)):
    colsum = 0
    rowsum = 0
    diagsum = diagsum + s[i][i]
    revdiagsum = revdiagsum + s[i][len(s) - i - 1]
    for j in range(0, len(s)):
        rowsum = rowsum + s[j][i]
        colsum = colsum + s[i][j]
    if colsum != target or rowsum != target:
        return False
 return diagsum == target and revdiagsum == target


def listNegateEveryOther(lst):
    for i,pos in zip(lst,range(0,len(lst))):
        if(pos != 1):
           lst[pos] = -i

def makeMaxilative(lst):
    max_v = 0
    for i,pos in zip(lst,range(0,len(lst))):
        if(max_v >= i):
           lst[pos] = max_v
        else:
           max_v = i
           lst[pos] = i 