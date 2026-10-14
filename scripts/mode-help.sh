#!/bin/sh
# Called in a popup after leaving the original mode. --print reads the help
# without opening a pager, for documentation and configuration checks.
set -eu
mode=${1:?mode required}
socket=${2:?tmux socket required}

help_text() {
    printf 'TMUX HELP: %s\n\n' "$mode"
    printf 'The original mode has been exited. Quit help to return to terminal input.\n'
    printf 'Pager: j/k or arrows scroll, Space next page, / searches, q quits.\n\n'
    case "$mode" in
        windows-picker|sessions-picker)
            cat <<'HELP'
Window/session picker controls (tmux 3.2+):

  j / Down         Select next item
  k / Up           Select previous item
  h / -            Collapse selected item
  l / +            Expand selected item
  Enter            Select item
  Escape / q       Cancel picker and return to normal input
  Ctrl+h           Exit picker and show this help
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

Selecting in the window picker enters persistent window mode.
The session picker opened by prefix+s returns to normal input; opened from
window mode, it returns to window mode after selection.
HELP
            ;;
        tmux-window|tmux-pane|tmux-resize|copy-mode|copy-mode-vi)
            tmux -S "$socket" list-keys -aN -T "$mode"
            ;;
        *)
            printf 'Unknown mode: %s\n' "$mode" >&2
            return 1
            ;;
    esac
    printf '\nCtrl+h may also be sent by Backspace, depending on your terminal.\n'
    printf 'Custom modes: Enter/Escape exit; unbound keys are ignored.\n'
    printf 'Actions stay in their mode until you explicitly exit or open help.\n'
}

if [ "${3-}" = --print ]; then
    help_text
else
    help_text | less -R
fi
