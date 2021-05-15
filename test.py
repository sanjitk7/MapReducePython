#!/usr/bin/env python3

try:
    with open("./temp/test.txt", encoding = 'utf-8') as f:
        print(f.read())
except IOError:
    print(IOError)
    