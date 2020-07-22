def common_phrases(d1, d2):
    keys = d1.keys()
    common = {}
    for k in keys:
        if k in d2:
            common[k] = (d1[k], d2[k])
    return common


def phrase_collector(text, plen):
    d = {}
    words = text.split()
    words = map(lambda s: s.lower(), words)
    print words
    for windex in range(0, len(words) - plen):
       phrase = tuple(words[windex:windex+plen])
       if phrase in d:
           d[phrase] = d[phrase] + 1
       else:
           d[phrase]= 1
    return d

def show_phrases(d):
    keys = d.keys()
    okeys = sorted(keys, lambda k1, k2: (d[k2][0]+d[k2][1]) - (d[k1][0]+d[k1][1]))
    for k in okeys:
        print str(k) + ": " + str(d[k])
        
import urllib
myhomepage = urllib.urlopen('http://www.cs.virginia.edu/evans/index.html').read()
declaration = urllib.urlopen('http://www.cs.virginia.edu/~evans/cs1120-f11/syllabus').read()

pde = phrase_collector(myhomepage, 3)
ptj = phrase_collector(declaration, 3)
show_phrases(common_phrases(ptj, pde))