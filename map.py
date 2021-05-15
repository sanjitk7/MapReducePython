#!/usr/bin/env python3
import re
try:
    with open("./data/data.txt", encoding = 'utf-8') as f:
        d = f.read()
        l = d.split(" ")
        for x in l:
            print((x,1))
except IOError:
    print(IOError)
    