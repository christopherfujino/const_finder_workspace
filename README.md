To setup repo:

Create a new directory:

```
mkdir const_finder_workspace
cd const_finder_workspace
```

Then create a `.gclient` file:

```
solutions = [
  {
    "name": "tools",
    "url": "git@github.com:christopherfujino/const_finder_workspace",
  },
]

# vim: set ft=python:
```

And initialize the repo:

```
gclient sync
```
