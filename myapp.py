#!/usr/bin/env python

import sys

if len(sys.argv) < 2:
    param = "World"
else:
    param = sys.argv[1]

print('Hello {}'.format(param))
