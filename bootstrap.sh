#!/bin/sh
# Script to build Playground-sampler project

# install dependencies via Carthage
echo "Install dependencies via Carthage"
carthage bootstrap --no-use-binaries --cache-builds --platform ios

# set projectname
open Playground-sampler.xcodeproj
