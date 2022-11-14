# !/bin/bash
# local
git branch -D $BRANCH
# remote (if branch is not protected remotely, like it not being the default branch)
git push $REMOTE --delete $BRANCH
