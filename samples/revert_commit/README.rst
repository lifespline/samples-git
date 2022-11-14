=============
Commit Revert
=============

About
-----

Revert from a commit.

Samples
-------

Let's create two commits and revert from the last.

.. code:: bash

    $ echo line 1 > file
    $ git status
    ...
    Untracked files:
        file
    $ git add file
    $ git status
    ...
    Changes to be committed:
        new file:   file
    $ git commit -m "commit"
    ...
    1 file changed, 1 insertion(+)
    create mode 100644 file
    $ echo line 2 >> file
    $ git status
    ...
    Changes not staged for commit:
    ...
        modified:   file
    $ git add file
    $ git status
    ...
    Changes to be committed:
    ...
        modified:   file
    $ git commit -m "commit"
    ...
    1 file changed, 1 insertion(+)
    $ git log --oneline
    0ef2789 (HEAD -> master) commit
    6bf8fea commit



Literature
----------

* `atlassian <https://www.atlassian.com/git/tutorials/undoing-changes/git-revert>`_