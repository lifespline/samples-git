#!/bin/bash
# set branch description
git branch --edit-description $BRANCH_NAME
# show branch description
git config branch.${BRANCH_NAME}.description
