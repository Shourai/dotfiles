# git

Linked to `~/.config/git` by `setup/link.sh`; git reads `~/.config/git/config` as the global
config, so there is no `~/.gitconfig`.

| File                  | In the repo | Contains                                                 |
|-----------------------|-------------|----------------------------------------------------------|
| `config`              | yes         | settings, aliases, identity per folder                   |
| `gitconfig_personal`  | yes         | name and email for repos in `~/Documents/github/`        |
| `gitconfig_work`      | **no**      | name and email for repos in `~/Documents/gitlab/`; create it on each machine (gitignored) |

## Identity per folder

There is no global name or email: repos in `~/Documents/github/` get `gitconfig_personal`, repos in
`~/Documents/gitlab/` get `gitconfig_work`. Anywhere else git refuses to commit until you set an
identity in that repo (`user.useConfigOnly`), so nothing is committed under a guessed name.

Work identity, `~/.config/git/gitconfig_work`:

```gitconfig
[user]
  name = Your Name
  email = you@work.example
```

## Behaviour worth knowing

| Setting                     | Effect                                                              |
|-----------------------------|---------------------------------------------------------------------|
| `pull.ff = only`            | `git pull` refuses when local and remote have diverged; then `git pull --rebase` or `git merge` yourself |
| `push.autoSetupRemote`      | the first `git push` of a new branch needs no `-u origin <branch>`  |
| `fetch.prune`               | branches deleted on the remote disappear locally on fetch           |
| `merge.conflictStyle zdiff3`| conflict markers also show the original text (between `\|\|\|\|\|\|\|` and `=======`) |
| `rerere.enabled`            | a conflict resolved once is resolved the same way next time         |

## Aliases

Most are short forms (`st`, `d`, `ds`, `co`, `cb`, `p`, `l` = pull, ...); see `config`.

| Alias            | What it does                                                   |
|------------------|----------------------------------------------------------------|
| `cm`             | check out the default branch (`main` or `master`)              |
| `mom`            | merge `origin/<default branch>` into the current branch        |
| `default-branch` | print the default branch name                                  |
| `lg`             | compact graph of the last 20 commits                           |
