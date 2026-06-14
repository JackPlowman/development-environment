#!/bin/bash

BASE_BRANCH=$(git rev-parse --abbrev-ref origin/HEAD 2>/dev/null)
# Run the automated rebase targeting the base branch instead of HEAD~N
GIT_SEQUENCE_EDITOR='uv run squash_by_day.py' GIT_EDITOR=true git rebase -i $BASE_BRANCH
