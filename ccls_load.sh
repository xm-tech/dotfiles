#!/bin/sh

# Homebrew clang is a bit different from /usr/bin/clang. 
# This script configures ccls with the correct include paths for macOS.
# To get your system's include paths, run: clang++ -xc++ -fsyntax-only -v /dev/null

ccls_path=$(brew --prefix ccls)
exec "${ccls_path}/bin/ccls" --init='{"clang":{"extraArgs":[
  "-std=c11",
  "-isystem/usr/local/include",
  "-isystem/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1",
  "-isystem/Library/Developer/CommandLineTools/usr/lib/clang/16/include",
  "-isystem/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include",
  "-isystem/Library/Developer/CommandLineTools/usr/include",
  "-isystem/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks"
]},
"cache": {
  "directory": "~/.ccls-cache"
}}' "$@"

# Uncomment and modify if you need additional library includes:
# "-isystem/usr/local/Cellar/sdl2/2.24.0/include/SDL2"
