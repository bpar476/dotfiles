# ZSH

This module configures the ZSH environment. This includes:

* aliases
* theme ([Dracula](https://draculatheme.com/zsh/))
* fuzzy-find in history search
* zsh plugins
* preferred editor
* Support local overrides

## Aliases

|  alias       | command                        |                                           action                                          |
|--------------|--------------------------------|-------------------------------------------------------------------------------------------|
| `..`         | `cd ..`                        | go back a directory                                                                       |
| `vi`         | `nvim`                         | Open neovim                                                                               |
| `rzshrc`     | `source $HOME/.zshrc`          | reloads zsh config                                                                        |
| `ezshrc`     | `nvim $HOME/.zshrc`            | edits zsh config (propagates to repo because of symlink)                                  |
| `grep`       | `ggrep --colour`               | override system grep with gnu grep                                                        |
| `cleandocker`| `docker rm $(docker ps -a -q)` | prunes hanging docker containers                                                          |
| `gs`         | `git status`                   |                                                                                           |
| `gp`         | `git push`                     |                                                                                           |
| `gc`         | `git commit`                   |                                                                                           |
| `gca`        | `git commit --amend`           | opens the previous commit for editing                                                     |
| `gcm`        | `git commit -m`                | makes a git commit a command line message. e.g. `gcm "my commit message"`                 |
| `gd`         | `git diff`                     |                                                                                           |
| `gdc`        | `git diff --cached`            | shows the diff between the HEAD commit and the index                                      |
| `ga`         | `git add`                      |                                                                                           |
| `gap`        | `git add -p`                   | interactively select hunks of changes to add to the index                                 |
| `gaa`        | `git add --all`                | adds all changes to the index                                                             |
| `gl`         | `git log`                      |                                                                                           |
| `gpl`        | `git pull`                     |                                                                                           |
| `gpr`        | `git pull --rebase`            | Equivalent to `git fetch && git rebase origin/<branch>`                                   |
| `grhh`       | `git reset HEAD --hard`        | resets the working tree to the HEAD commit. ALL CHANGES WILL BE LOST, EVEN STAGED CHANGES |

## Fuzzy Find

`fzf` is installed by the vim config and can be re-purposed to also provide fuzzy find for history back-search. Hit `CTRL+R` and then type for fuzzy
matching of your command history

