||f/feature|f/feature/final|release|latest|
|:-|:-|:-|:-|:-|
|commit|✔️|❌|❌|❌|
|push|✔️|✔️|❌|❌|
|pull|✔️|✔️|✔️|✔️|
|merge\*|✔️|✔️|✔️|✔️|
|delete|⚠️|✔️|❌|❌|
|squash-all|❌|❌|❌|❌|
|tag|✔️||||

|**merge**|f/feature|f/feature/final|release|latest|
|:-|:-|:-|:-|:-|
|f/feature|✔️|❌|❌|❌|
|f/feature/final|✔️|✔️|✔️|❌|
|release|❌|✔️|✔️|✔️|
|latest|❌|❌|✔️|✔️|


## f/feature

+ feature is related to the release version
+ commits related to the feature are **tagged**
+ commits unrelated to the feature should be merged with a different feature

## f/feature/final

+ select from `f/feature` which commits to release to the `release` branch.
+ squashes all commits before merging with `release`


## release

+ accepts the merge of a **single commit**
+ merges with `latest` with the message: `release <version>`