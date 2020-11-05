#!/usr/bin/env bash

cd functions

# Get dependencies
pub get

# get npm packages
npm install --save firebase-admin
npm install --save bad-words

# Build project
pub run build_runner build --output=build

# Uploading functions to firebase
firebase deploy --only functions

# Uploading rules to firebase
cd ..
firebase deploy --only firestore:rules