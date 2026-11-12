#!/bin/sh
# Called in a popup over the original mode. --print reads the help
# without opening a pager, for documentation and configuration checks.
set -eu
mode=${1:?mode required}
socket=${2:?tmux socket required}

case "$mode" in
    prefix) title='Command mode' ;;
    tmux-window) title='Window mode' ;;
    tmux-resize) title='Resize mode' ;;
    copy-mode|copy-mode-vi) title='Copy mode' ;;
    windows-picker) title='Window picker' ;;
    sessions-picker) title='Session picker' ;;
    *) printf 'Unknown mode: %s\n' "$mode" >&2; exit 1 ;;
esac

# Only show bindings with notes; -a would expose raw commands for unnoted keys.
help_text() {
    printf '%s — key bindings\n\n' "$title"
    printf '  j/k or arrows: scroll   Space: next page   /: search   q: close\n\n'
    case "$mode" in
        prefix)
            tmux -S "$socket" list-keys -N -T prefix
            ;;
        windows-picker|sessions-picker)
            cat <<'HELP'
Window/session picker controls (tmux 3.2+):

  j / Down         Select next item
  k / Up           Select previous item
  h / -            Collapse selected item
  l / +            Expand selected item
  Enter            Select item
  Escape / q       Cancel picker and return to normal input
  ?                Show help; close it to return to the picker
  Alt+- / Alt++    Collapse / expand all items
  Ctrl+s           Search by name
  n                Repeat search
  f                Filter items
  O / r            Change sort field / reverse sort
  v                Toggle preview
  < / >            Scroll previews left / right
  H                Jump to starting pane
  t / T / Ctrl+t   Toggle tag / clear tags / tag all
  :                Run command on tagged items
  m / M            Mark pane / clear mark
  x / X            Close selected / tagged items (confirmation)
  [shortcut]       Select the item with the shortcut shown beside it

Open the window picker with p in window mode (prefix+w).
Selecting in the window picker returns to persistent window mode.
The session picker opened by prefix+s returns to normal input; opened from
window mode, it returns to window mode after selection.
HELP
            ;;
        tmux-window|tmux-resize|copy-mode|copy-mode-vi)
            tmux -S "$socket" list-keys -N -T "$mode"
            ;;
        *)
            printf 'Unknown mode: %s\n' "$mode" >&2
            return 1
            ;;
    esac
    printf '\nClose help to return to the original mode or picker.\n'
}

if [ "${3-}" = --print ]; then
    help_text
else
    help_text | LESS= LESSOPEN= LESSCLOSE= less -R -~ -i -P " $title help | j/k scroll | / search | q close "
fi
