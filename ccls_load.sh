#!/bin/sh

# Homebrew clang is a bit different from /usr/bin/clang. Invoke clang++ -xc++ -fsyntax-only -v /dev/null to get a list of C/C++ search paths. 
# then add them as -isystem into the shell script wrapper. For example:
exec /usr/local/bin/ccls --init='{"clang":{"extraArgs":[
  "-std=c11",
  "-isystem/usr/local/include",
  "-isystem/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1",
  "-isystem/Library/Developer/CommandLineTools/usr/lib/clang/14.0.0/include",
  "-isystem/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include",
  "-isystem/Library/Developer/CommandLineTools/usr/include",
  "-isystem/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks"
]}}' "$@"
#  "-isystem/usr/local/Cellar/sdl2/2.24.0/include/SDL2"
