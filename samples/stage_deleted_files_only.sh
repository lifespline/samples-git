#!/bin/bash
# stage only the files that were deleted
git add $(git ls-files --deleted)