#!/bin/bash

git branch | grep -v "main" | grep -v "master" | xargs git branch -D
