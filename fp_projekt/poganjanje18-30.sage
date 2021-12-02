#!/usr/bin/env python
# coding: utf-8

%load funkcije.sage

import json

data = {}
od, do = 3, 9
for n in range(od, do+1, 3): 
    d = pozeni(n) 
    data[n] = d 
    with open(f"poganjanje{od}-{do}.json", "w") as f: 
        json.dump(data, f, indent=2)
