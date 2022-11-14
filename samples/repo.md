- [About](#about)
- [Understanding Versioning And Control: A Biased Introduction](#understanding-versioning-and-control-a-biased-introduction)
- [Creating A New Repo: Initial Branching](#creating-a-new-repo-initial-branching)
- [Branch Semantics And Policies](#branch-semantics-and-policies)
  - [`latest`](#latest)
  - [`release/*`](#release)
  - [`tst`](#tst)
  - [`dev`](#dev)
  - [`feature/*`](#feature)
  - [`task/*`](#task)
  - [`subtask/*`](#subtask)
  - [`issue/*`](#issue)
- [Pull Requests and Merging Remarks](#pull-requests-and-merging-remarks)
- [Commit Semantics And Rules](#commit-semantics-and-rules)
  - [`lint`](#lint)
  - [`format`](#format)
  - [`doc`](#doc)
  - [`dev`](#dev-1)
  - [`sugar`](#sugar)
  - [`performance`](#performance)
  - [`refactor`](#refactor)
  - [`fix`](#fix)
  - [`clean`](#clean)
  - [`merge`](#merge)
  - [`dependency`](#dependency)
  - [`config`](#config)
  - [`ignore`](#ignore)
- [Semantic Versioning](#semantic-versioning)
- [Testing](#testing)
- [Linting](#linting)
- [Formatting](#formatting)
- [Debugging](#debugging)
- [Editing](#editing)

# About

The guide shows how to setup the git repository in Azure DevOps and how to operate git to optimize your development operations.

# Understanding Versioning And Control: A Biased Introduction

`versioning-and-control` (+ devops + principles + standards) is the embedded framework on a collective of (1+) developers mind with which it conceptualizes the development of a software solution. The development of a software solution is:

1. digital components (a component is either a component, or an integration of components)
2. split across files
3. layed out in a structure

A `component` is the solution at the timestamp of a `commit`. A `branch` is an encapsulated copy of a `component` that we wish to develop. A `merge` is merging this component with the existing solution (always keep in mind you're hardly ever the only one branching). A `commit` or a set of commits are a unit of work decoupable from the solution.

![image][versioning-and-control]

# Creating A New Repo: Initial Branching

When you create a new repo, branch as:

```
latest
│
├╴ tst
│  │   
│  ├╴ release/*
│  │  │
│  │  ├╴ task/* [optional]
│  │  │  ┊
│  │  │  commit
│  │  │
│  │  ├╴ task/* [optional]
│  │  │  │
│  │  │  ├╴ subtask/* [optional]
│  │  │  │  ┊
│  │  │  │  commit
│  │  │  │  commit
│  │  │  ┊
│  │  ┊
│  │  commit
│  │
│  ├╴ dev
│  │  │
│  │  ├╴ feature/*
│  │  │  │
│  │  │  ├╴ task/*
│  │  │  │  ┊
│  │  │  │  commit
│  │  │  │
│  │  │  ├╴ task/*
│  │  │  │  │
│  │  │  │  ├╴ subtask/* [optional]
│  │  │  │  │  ┊
│  │  │  │  │  commit
│  │  │  │  │  commit
│  ┊  ┊  ┊  ┊
│
├╴ issue/*
┊
```

The example below has the following structure:

```
latest
├╴ tst
│  ├╴ dev
│  │  ├╴ feature/init_readme
│  │  │  ├╴ task/wipe_readme
│  │  │  ├╴ task/write_readme
```

![image][init-repo]

Mind that the `feature/*` and `task/*` branches were created through the [backlog tasks][backlog] so the tasks can be traced back to the repository. Read more about branching the tasks and about the branching policies in [branching policies](#branching-policies).

[⌂ home](#about)

# Branch Semantics And Policies

A branch encapsulates a **unit of work**, be it a `feature`, a `task` or a `subtask`. The developer is encouraged to add branches the descriptions added in the scrum board by running:

```shell
$ git branch --edit-description
```

Which opens a CLI editor so that the description be persisted:

```txt
multiline branch
description here
# Please edit the description for the branch
#   feature/bootstrap_template
# Lines starting with '#' will be stripped.
```

The branch semantics and policies follow below:

## `latest`
  + `description`: The `latest` branch is a repository for stable and versioned releases from `release/*` (or from `tst` directly).
  + It is the `default` branch
  + `branch`: `tst`
  + It is the `compare` branch, meaning all other branches compare to the release branch individually (number of commits behind/ahead).
  + The branch is **permanent**.
  + ~~`delete`~~
  + ~~`push`/`commit`~~
  + `pull`
  + `merge`: `latest` or `tst/*` iff:
    + All `tst/*` tests are passing or,
    + All `release/*` tests are passing
    + No conflicts
    + `squash`: The merge is a single commit
  +  Created by: `product-owner`

## `release/*`
  + `description`: This is the `release` branch. As features are merged together in `tst`, `release/*` encapsulates a new release independent from previous releases. Each release contains a `changelog.md` that documents breaking changes, enhancements, *etc.*. `latest` is simply a historic of releases, but that historic is not sufficient to understand the dependencies between the releases. Read `changelog.md` for the dependency tree.
  + `branch`: `tst`
  + The branch is **temporary**.
  + ~~`delete`~~
  + ~~`push`/`commit`~~
  + `pull`
  + `merge` from `dev/*` only such that:
    + All `dev/*` tests are passing
    + No conflicts
  + ~~`squash`~~
  + Created by: `product-owner`

## `tst`
  + This is the `test` branch that merges all the `features`.
  + `branch`: `latest`
  + The branch is **permanent**.
  + ~~`delete`~~
  + ~~`push`/`commit`~~
  + `pull`
  + `merge` from `dev/*` only such that:
    + All `dev/*` tests are passing
    + No conflicts
  + ~~`squash`~~
  + ~~`description`~~ The description is a default description
  + Created by: `product-owner`

## `dev`
  + This is the `development` branch that merges all the feature `tasks`.
  + It branches from `tst`
  + It branches to `feature/*`
  + The branch is **permanent**.
  + ~~`delete`~~
  + ~~`push`/`commit`~~
  + `pull`
  + `merge` from `feature/*` only such that:
    + All `feature/*` tests are passing
    + No conflicts
  + ~~`squash`~~
  + ~~`description`~~ The description is a default description
  + Created by: `product-owner`

## `feature/*`
  + This is the `feature` branch that merges all the feature `tasks`.
  + It branches from `dev`
  + It branches to `task/*`
  + The branch is **temporary**.
  + `delete`
  + `push`/`commit`
  + `pull`
  + `merge` from `task/*` only such that:
    + All `task/*` tests are passing
    + No conflicts
  + ~~`squash`~~
  + `description`
    + Created by the `product-owner` only
    + high-level description
    + `DOD`
  + Created by: `product-owner`

## `task/*`
  + This is the `task` branch that merges all the task's `commits` or the task's `subtasks`.
  + It branches from `feature/*`
  + It branches optionally to `subtask/*`
  + The branch is **temporary**.
  + `delete`
  + `push`/`commit`
  + `pull`
  + `merge` from `subtask/*` only such that:
    + All `subtask/*` tests are passing
    + No conflicts
  + ~~`squash`~~
  + `description`
    + high-level description
    + `DOD`
  + Created by: `dev`

## `subtask/*`
  + This is the `subtask` branch that merges all the subtask's `commits`.
  + The branch is **temporary**.
  + `delete`
  + `push`/`commit`
  + `pull`
  + `merge` from `task/*` only such that:
    + All `task/*` tests are passing
    + No conflicts
  + ~~`squash`~~
  + `description`
    + high-level description
    + `DOD`
  + Created by: `dev`

## `issue/*`
  + This is the `subtask` branch that merges all the subtask's `commits`.
  + It branches from `latest`
  + It branches to `latest`
  + The branch is **temporary**.
  + `delete`
  + `push`/`commit`
  + `pull`
  + `merge` from `latest` only such that:
    + `ISSUES.md` linting is passing
    + no conflicts
  + ~~`squash`~~
  + `description`
    + high-level description
    + `DOD`
  + Created by: `dev`, `product-owner`
  + The `dev` and `tst` will deviate from `latest` because they won't contain the commits to `ISSUES.md`, unless a `PR` is issued to `dev` and `tst` successively.

```
latest
│
├╴ tst
│  │
│  ├╴ dev
│  │  │
│  │  ├╴ feature/*
│  │  │  │
│  │  │  ├╴ task/*
│  │  │  │  ┊
│  │  │  │  commit
│  │  │  │
│  │  │  ├╴ task/*
│  │  │  │  │
│  │  │  │  ├╴ subtask/* [optional]
│  │  │  │  │  ┊
│  │  │  │  │  commit
│  │  │  │  │  commit
```


[⌂ home](#about)

# Pull Requests and Merging Remarks

It goes without saying, but merging your work from `A` into a contribution branch `B` with a `PR`, start by pulling `B` and merging with `A` to guarantee all tests are still passing and that there are no merging conflicts. If this is the case, submit a `PR` from `A` to `B`. This will reduce the `PR`s waiting for errors to be fixed before merging. After merging the `PR`, pull the changes merged with `B` and delete `A` if it was also deleted in remote.

A merge sould always happen with a `squash` first. If the test pass, the merge is completed and the branch deleted. Otherwise the developer can determine the problem in the unquashed commits. But if the merge can happen, it's safe to squash because there's no interest in persisting the history of changes.

[⌂ home](#about)

# Commit Semantics And Rules

A `commit` is an **atomic unit of work** on the implementation of a feature, or otherwise.

```sh
6f844f9 doc: readme
122fcdc doc, refactor: mv docs
8810f6b refactor: listBucket
a0a9a1d lint
a5b25c5 doc
08983b7 dev
0b7cb4d refactor
02e82f6 dev: lambda
f78f050 dev
49f0f31 dev
c4e8ed3 dev, dependencies
```

If a commit doesn't belong to the implementation of the feature, it should not be squashed before being merged with whichever parent branch. Say that the `doc` commits on the example above, none of them are related to the feature, they are not documenting the feature, but were added while working on the feature. In this case, the squash should include all commits but these.

Commits MUST follow the spec:

```
<work-type>: <bookmark>

[<description>]
```

A commit has at least one [work-type](#nature-of-a-commit) AND one `<bookmark>`. The `<bookmark>` is a note to ease the navigation across the commits. The `<description>` is optional. Ideally the commit contents should be atomic and simple enough to describe the change itself. Committing a documentation operation should replace the operation:

```shell
git commit -m "doc: readme"
```

With:


```shell
Ctrl+R
(reverse-i-search)`readme': git commit -m "doc: readme"
```

`<work-type>` describes the **type of work** of the commit and is (non-exhaustively) one of:

## `lint`

Linting operations

## `format`

Formatting operations

## `doc`

Adding documentation, be it `docstrings` or `inline doc` or a `README.md` file.

## `dev`

Writing unit tests for dev logic + dev logic. Ideally, no dev logic should be committed without unit tests. Example:

- Staging and committing `resource/lambda/handler.ts` and `resource/lambda/Dockerfile`

## `sugar`

Beautifying changes to the code

## `performance`

Improving the code performance

## `refactor`

Code refactoring. Examples:

- renaming a component. Differs from [fix](#fix) if the name is changing as a **decision**, not because it was **incorrect**.

## `fix`

- Fixing code that was not working as expected
- Fixing a component's name. Differs from [refactor](#refactor) if the name was **incorrect**.

[⌂ home](#about)

## `clean`

Remove logic or files that were left forgotten and are no longer required. Ideally, add a description to these commits explaining why those files/logic was deleted by the commit.

[⌂ home](#about)

## `merge`

Merge the work between two branches.

[⌂ home](#about)

## `dependency`

Add system/application dependencies.

[⌂ home](#about)

## `config`

Change configuration. Examples:

- Editing `tsconfig.json::include` to exclude `"resource/*/*.ts"`

[⌂ home](#about)

## `ignore`

ignoring files from ever being staged.


[⌂ home](#about)

# Semantic Versioning

Read more at [semantic versioning](semantic_versioning.md).

[⌂ home](#about)

# Testing

Read more at [testing](testing.md).


[⌂ home](#about)

# Linting

Read more at [linting][linting.md].


[⌂ home](#about)

# Formatting

Read more at [formatting][formatting.md].


[⌂ home](#about)

# Debugging

Read more at [debugging][debugging.md].


[⌂ home](#about)

# Editing

Read more at [editing with VSCode][vscode.md].

[init-repo]: img/init_repo.png "Initialize a repositories branches"
[backlog]: https://dev.azure.com/novonordiskit/CMC%20Data%20Foundation/_backlogs/backlog/CMC%20Data%20Foundation%20Team/Epics
[versioning-and-control]: img/versioning_and_control.png "Versioning And Control: Local And Remote"
[backlog]: https://dev.azure.com/novonordiskit/CMC%20Data%20Foundation/_backlogs/backlog/CMC%20Data%20Foundation%20Team/Epics