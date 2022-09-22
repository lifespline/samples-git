# create a commit reverting from commit $COMMIT_HASH
git revert $COMMIT_HASH

# delete commits excluding commit $COMMIT_HASH
git reset --hard $COMMIT_HASH
