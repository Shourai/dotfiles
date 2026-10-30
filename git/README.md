# git

Linked to `~/.config/git` by `setup/link.sh`. Git reads `~/.config/git/config` as the global config,
so there is no `~/.gitconfig`.

| File                  | In the repo | Contains                                                 |
|-----------------------|-------------|----------------------------------------------------------|
| `config`              | yes         | settings, aliases, identity per folder                   |
| `gitconfig_personal`  | yes         | name and email for repos in `~/Documents/github/`        |
| `gitconfig_work`      | **no**      | name and email for repos in `~/Documents/gitlab/` (gitignored, create it per machine) |

## Identity per folder

There is no global `user.name`/`user.email`. The identity depends on where the repo lives:

- `~/Documents/github/**` -> `gitconfig_personal`
- `~/Documents/gitlab/**` -> `gitconfig_work`
- anywhere else -> no identity; git refuses to commit until you set one, so nothing is committed under the wrong name.

To set up the work identity on a machine, create `~/.config/git/gitconfig_work`:

```gitconfig
[user]
  name = Your Name
  email = you@work.example
```

## Behaviour worth knowing

| Setting                     | Effect                                                              |
|-----------------------------|---------------------------------------------------------------------|
| `pull.ff = only`            | `git pull` refuses when local and remote have diverged; then run `git pull --rebase` or `git merge` yourself |
| `push.autoSetupRemote`      | first `git push` of a new branch needs no `-u origin <branch>`      |
| `fetch.prune`               | branches deleted on the remote disappear locally on fetch           |
| `merge.conflictStyle zdiff3`| conflict markers show the original text between `\|\|\|\|\|\|\|` and `=======` |
| `rerere.enabled`            | a conflict you resolved once is resolved the same way next time     |

## Aliases

Most aliases are short forms (`st`, `d`, `ds`, `co`, `cb`, `p`, `l` = pull, ...); see `config`.

| Alias            | What it does                                                   |
|------------------|----------------------------------------------------------------|
| `cm`             | check out the default branch (`main` or `master`)              |
| `mom`            | merge `origin/<default branch>` into the current branch        |
| `default-branch` | print the default branch name (used by `cm` and `mom`)         |
| `lg`             | compact graph of the last 20 commits                           |
