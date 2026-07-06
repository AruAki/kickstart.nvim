#!/usr/bin/env bash
FILE="$1"
LINE="$2"
COL="$3"
SOCK="/tmp/godot.nvim"

if nvim --server "$SOCK" --remote-expr '1' >/dev/null 2>&1; then
  nvim --server "$SOCK" --remote-send \
    "<C-\\><C-n>:e ${FILE}<CR>:call cursor(${LINE},${COL})<CR>"
else
  kitty nvim --listen "$SOCK" "+call cursor(${LINE},${COL})" "${FILE}" &
fi
