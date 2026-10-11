# tmux configuration

Shared tmux settings for Linux, macOS, and Windows through WSL. Install tmux
and Git separately. This configuration has no plugin dependencies.

## Standalone installation

Clone this repository into a permanent directory, then link its configuration:

```sh
git clone https://github.com/TenofHearts/tmux-config.git "$HOME/tmux-config"
```

Back up an existing `~/.tmux.conf` before creating the link. If you already
installed these settings with the dotfiles installer, keep that existing link.
For a new standalone installation:

```sh
ln -s "$HOME/tmux-config/.tmux.conf" "$HOME/.tmux.conf"
```

Run these commands inside WSL on Windows. Each machine needs its own clone
and symlink. Keep the clone in place so the link continues to work.

Reload the settings in a running tmux session:

```sh
tmux source-file "$HOME/.tmux.conf"
```

## Bindings

- Prefix: `Ctrl-a`; press `Ctrl-a` twice to send it to the application.
- Prefix then `c`: create a window in the current pane's working directory.
- Prefix then `%` or `"`: split horizontally or vertically in that directory.
- `Alt` + arrow keys: switch panes without the prefix.
- Mouse support is enabled; automatic window renaming is disabled.

## Sync between machines

Edit `.tmux.conf` in the clone, then commit and push:

```sh
git -C "$HOME/tmux-config" add .tmux.conf
git -C "$HOME/tmux-config" commit -m "Update tmux settings"
git -C "$HOME/tmux-config" push
```

On another machine:

```sh
git -C "$HOME/tmux-config" pull --ff-only
tmux source-file "$HOME/.tmux.conf"
```

When used as a dotfiles submodule, work inside `config/tmux` instead. After
committing and pushing here, commit the updated `config/tmux` reference in
the parent repository. Other dotfiles checkouts can then use `git pull`
followed by `git submodule update --init --recursive` to get that revision.
