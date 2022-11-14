#!/bin/bash
# check what will be deleted
git clean -n -d
# delete all untracked files and dirs
git clean -d -f
