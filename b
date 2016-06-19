#!/bin/sh
# Build script
volt -o injiki src/main.volt -src-I src `pkg-config --libs gtk+-3.0` -Xcc -rdynamic -J .
