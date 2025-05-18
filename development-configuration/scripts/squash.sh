#!/bin/bash

git reset --soft "$(git merge-base main HEAD)"

git commit -m "Squashed"
