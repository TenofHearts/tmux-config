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

New windows and panes use `TERM=screen-256color` so zsh syntax highlighting can
use its configured 256-color palette. After reloading, open a new pane/window
to pick up this setting. In an existing zsh pane, run
`export TERM=screen-256color` to refresh its terminal capabilities.

## Bindings

The prefix is **Ctrl+a**: release both keys, then press the next key. Press
Ctrl+a twice to send it to the application. Mouse support is enabled;
automatic window renaming is disabled.
Escape waits only 10 ms for a possible Alt-key sequence, so exiting modes and
canceling prompts feels immediate.

| Entry | Mode | Badge color |
| --- | --- | --- |
| Prefix `Ctrl+a` | Command mode, including pane controls | Yellow |
| Prefix `w` | Window controls | Blue |
| Prefix `r` | Resize controls | Orange |
| Prefix `s` | Built-in session picker | Blue |
| Prefix `[` | Built-in copy mode, with vi navigation | Purple |

Pane actions stay in command mode. Every action in window and resize modes
stays in that mode, including create, rename, and confirmed close.
**Enter or Escape exits** to normal terminal input. Unbound keys are ignored. Closing the last pane/window can still end its
session. Prefix shortcuts remain available for changing modes or detaching.

**`?` opens help for the current mode in a floating tmux popup**, including
command mode (Ctrl+a then `?`). Bindings use tmux's native key-and-description
listing, with a mode title and a navigation hint. Press `q` to close help
and return to the original mode or picker. Copy selections, scroll positions,
and picker state stay in place beneath the popup.
Help supports arrows, page scrolling, and `/` search. Custom-mode help is
generated from active bindings with descriptions; bindings without descriptions
are omitted so raw tmux commands never appear in help; built-in picker
controls are documented separately in the helper script.

Outside modes, `?` is forwarded to the application. In copy mode, `?` opens
help in place of backward search; `/` still searches forward.
While a rename/confirmation prompt is open,
keys belong to that prompt. Enter accepts a rename; **x confirms closing** a
pane/window and **Escape cancels**, returning to the command/window mode. Close prompts
display `x: yes | Esc: no` in the status bar. The direct prefix `x` (close pane)
and prefix `&` (close window) shortcuts use these same confirmation keys.
The built-in pickers' own `x`/`X` delete prompts use tmux's fixed `y` confirmation
in tmux 3.2; select a window and use window mode `x` for the customized prompt.

Alt+h/j/k/l and Alt+Arrow are left to the desktop window manager, including
GlazeWM. Mode colors are displayed in the status badge rather than changing
the entire status bar.

### Window mode

Prefix `w` enters persistent window controls immediately. Press `p` in window
mode to open the built-in window picker. Within the picker, `j/k` select entries
and `h/l` collapse/expand them. Enter selects an entry and returns to window
controls. Escape or `q` cancels to normal input.

| Key | Action |
| --- | --- |
| `h` / `l`, Left / Right | Previous / next window |
| `j` / `k`, Down / Up | Next / previous session |
| Tab | Previously active window |
| `0`–`9` | Select window by number |
| `c` | Create window in the current directory |
| `r` | Rename window |
| `p` | Open window picker; selection returns to window controls |
| `s` | Open session picker; selection returns to window controls |
| `x` | Close window, with confirmation |

The session picker opened directly by prefix `s` returns to normal input after
selection. Either picker can be canceled with Escape or `q`.

### Pane controls in command mode

| Key | Action |
| --- | --- |
| `h/j/k/l`, arrow keys | Focus left/down/up/right |
| Tab | Previously active pane |
| `=` | Split side by side |
| `-` | Split top and bottom |
| `z` | Toggle focused pane zoom |
| Space | Cycle layouts |
| `{` / `}` | Swap with previous / next pane |
| `!` | Move pane into its own window |
| `x` | Close pane, with confirmation |

Press Ctrl+a to enter command mode, then use these keys directly. Pane actions
keep command mode active, so navigation can be repeated without another prefix.
Enter or Escape returns to terminal input; unbound keys are ignored. All splits
start in the current pane's directory. After splitting, exit command mode before
typing into the new terminal. Previously active window remains available through
window mode Tab.

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
The split aliases also stay in command mode; creating a window returns to
normal input. Prefix `n` selects the next window; prefix **`b`** selects the
previous window; prefix `p` also selects the previous window. Prefix `d` detaches.
Prefix `?` opens command-mode help. Prefix `]` pastes the tmux buffer. Prefix `_`
deletes the latest paste buffer; prefix `+` opens the buffer picker (formerly
`-` and `=`).

In copy mode, `h/j/k/l` navigate, Space starts selection, Enter copies and exits,
and `q` or Escape exits. Copying uses tmux's buffer; clipboard behavior depends on terminal
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
