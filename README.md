# tmux configuration

Shared tmux settings for Linux, macOS, and Windows through WSL. Install tmux
3.2 or newer, Git, and `less` separately. This configuration has no plugin
dependencies. Keep `scripts/mode-help.sh` alongside `.tmux.conf`; the config
locates it automatically, including through the installation symlink.

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

The prefix is **Ctrl+a**: release both keys, then press the next key. Press
Ctrl+a twice to send it to the application. Mouse support is enabled;
automatic window renaming is disabled.

| Entry | Mode | Badge color |
| --- | --- | --- |
| Prefix `w` | Window picker, then window controls after selection | Blue |
| Prefix `p` | Pane controls | Green |
| Prefix `r` | Resize controls | Orange |
| Prefix `s` | Built-in session picker | Blue |
| Prefix `[` | Built-in copy mode, with vi navigation | Purple |

Every action in the three custom modes stays in that mode, including create,
split, rename, and confirmed close. **Enter or Escape exits** to normal terminal
input. Unbound keys are ignored. Closing the last pane/window can still end its
session. Prefix shortcuts remain available for changing modes or detaching.

**Ctrl+h opens help** for the current mode in a scrollable `less` popup. It exits
the original mode/picker first; `q` closes help and returns to normal input.
Help supports arrows, page scrolling, and `/` search. Custom-mode help is
generated from the active bindings and their descriptions; built-in picker
controls are documented separately in the helper script.

Ctrl+h and Backspace can produce the same code in some terminals. In that case,
Backspace also opens help while a mode is active. Outside modes, Ctrl+h is
forwarded to the application. While a rename/confirmation prompt is open,
keys belong to that prompt; Enter accepts and Escape cancels it, returning to
the custom mode.

Alt+h/j/k/l and Alt+Arrow are left to the desktop window manager, including
GlazeWM. Mode colors are displayed in the status badge rather than changing
the entire status bar.

### Window mode

Prefix `w` opens the built-in window picker immediately. Within the picker,
`j/k` select entries and `h/l` collapse/expand them. Enter selects an entry and
activates persistent window controls. Escape or `q` cancels to normal input.

| Key | Action |
| --- | --- |
| `h` / `l`, Left / Right | Previous / next window |
| `j` / `k`, Down / Up | Next / previous session |
| Tab | Previously active window |
| `0`–`9` | Select window by number |
| `c` | Create window in the current directory |
| `r` | Rename window |
| `w` | Reopen window picker |
| `s` | Open session picker; selection returns to window controls |
| `x` | Close window, with confirmation |

The session picker opened directly by prefix `s` returns to normal input after
selection. Either picker can be canceled with Escape or `q`.

### Pane mode

| Key | Action |
| --- | --- |
| `h/j/k/l`, arrow keys | Focus left/down/up/right |
| Tab | Previously active pane |
| `\|` | Split side by side |
| `-` or `=` | Split top and bottom |
| `z` | Toggle focused pane zoom |
| Space | Cycle layouts |
| `{` / `}` | Swap with previous / next pane |
| `!` | Move pane into its own window |
| `x` | Close pane, with confirmation |

All splits start in the current pane's directory. After splitting, exit pane
mode with Enter or Escape before typing into the new terminal.

### Resize mode

| Key | Action |
| --- | --- |
| `h/j/k/l`, arrow keys | Resize left/down/up/right by 2 cells |
| `H/J/K/L` | Resize left/down/up/right by 10 cells |
| `=` | Arrange even columns |
| `-` | Arrange even rows |

Even layouts rearrange panes as well as resize them.

### Direct shortcuts

Prefix `c` creates a window; `%` splits side by side; `"` splits top and bottom.
These direct shortcuts retain ordinary tmux behavior rather than entering a
custom mode. Prefix `n` selects the next window; prefix **`b`** selects the
previous window (prefix `p` now enters pane mode). Prefix `d` detaches.
Prefix `?` lists all bindings. Prefix `]` pastes the tmux buffer.

In copy mode, `h/j/k/l` navigate, Space starts selection, Enter copies and exits,
and `q` exits. Copying uses tmux's buffer; clipboard behavior depends on terminal
support and has not been customized here.

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
