#!/usr/bin/env python
# coding: utf-8

%load funkcije.sage

import json

data = {}
od, do = 18, 30
for n in range(od, do+1, 3): 
    d = pozeni(n) 
    data[n] = d 
    with open("poganjanje{}-{}.json".format(od, do), "w") as f:
        json.dump(data, f, indent=2)
