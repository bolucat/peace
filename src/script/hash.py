#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import hashlib
import argparse

parser = argparse.ArgumentParser(description='print file hashsum')
parser.add_argument('-f', '--file', nargs='*', help='file to be hashed', default='.')
args = parser.parse_args()

if args.file != '.':
    for file in args.file:
        print("SHA256 | " + file, ": " + hashlib.sha256(open(file, 'rb').read()).hexdigest())
        print("SHA512 | " + file, ": " + hashlib.sha512(open(file, 'rb').read()).hexdigest() + "\n")
else:
    for file in os.listdir(args.file):
        if os.path.isfile(file):
            if "/" not in sys.argv[0]:
                if file != sys.argv[0]:
                    print("SHA256 | " + file, ": " + hashlib.sha256(open(file, 'rb').read()).hexdigest())
                    print("SHA512 | " + file, ": " + hashlib.sha512(open(file, 'rb').read()).hexdigest() + "\n")
            else:
                self_name = sys.argv[0].split("/")[-1]
                if file != self_name:
                    print("SHA256 | " + file, ": " + hashlib.sha256(open(file, 'rb').read()).hexdigest())
                    print("SHA512 | " + file, ": " + hashlib.sha512(open(file, 'rb').read()).hexdigest() + "\n")