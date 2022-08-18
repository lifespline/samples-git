# squash

Add to `.git/config`:

```cfg
[alias]
  squash-all = "!f(){ git reset $(git commit-tree HEAD^{tree} -m \"${1:-init}\");};f"
```

\* commit default message: `init`
