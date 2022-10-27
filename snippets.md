# Snippets

> This provides a central place for commonly used snippets/commands that can be used across various tools.

---

## Tmux

Merge 2 windows into 1.
This will move the 2nd window as a pane to the 1st window.
Requires being in the target window (i.e. 1 in this case).

```bash
join-pane -s 2 -t 1
```

Rearrange windows.
This swaps the position of window 2 and 1.

```bash
swap-window -s 2 -t 1
```

## Vim

Delete up until a character (see :h t)

This deletes up until " character.
```text
dt"
```

Split on a given character

Ex: Split long line on commas
Visual select the line(s) then enter `:'<,'>s/,/\r/g`
```text
component:a, name:test, other:field
```
