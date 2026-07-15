#!/bin/sh
# Symlink everything in this repo into $HOME, mirroring the directory layout.
# Existing files are backed up to ~/.dotfiles-backup/<timestamp>/ before being replaced.

set -eu

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

find "$DOTFILES" -type f \
    ! -path "$DOTFILES/.git/*" \
    ! -name install.sh \
    ! -name README.md \
    ! -name .gitignore \
    | while read -r src; do
    rel="${src#"$DOTFILES"/}"
    dest="$HOME/$rel"

    mkdir -p "$(dirname "$dest")"

    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        mkdir -p "$BACKUP/$(dirname "$rel")"
        mv "$dest" "$BACKUP/$rel"
        echo "backed up: $rel"
    fi

    ln -sf "$src" "$dest"
    echo "linked:    $rel"
done

echo
echo "Done. Backups (if any) are in $BACKUP"
