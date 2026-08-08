#!/usr/bin/env bash
# Cai dat phu tro cho theme Deep Harbor tren mot may moi.
# Symlink dynamic profile do dotbot lo (xem install.conf.yaml).
#
#   bash ~/Dropbox/Projects/dotfiles/iterm2/apply.sh

set -euo pipefail

GUID="DEEPHARBOR-2026-FIN-01"

echo "==> Font: JetBrains Mono Nerd Font"
if ls ~/Library/Fonts /Library/Fonts 2>/dev/null | grep -q "JetBrainsMonoNerdFont"; then
  echo "    da co, bo qua"
elif command -v brew >/dev/null 2>&1; then
  brew install --cask font-jetbrains-mono-nerd-font || true
else
  echo "    !! chua co brew - cai tay tu https://www.nerdfonts.com/font-downloads"
fi

echo "==> Dat Deep Harbor lam profile mac dinh"
# Luu y: pgrep khong thay duoc process iTerm2 trong moi truong sandbox,
# osascript hoi truc tiep macOS nen dang tin cay hon.
if [ "$(osascript -e 'application "iTerm" is running' 2>/dev/null)" = "true" ]; then
  echo "    !! iTerm2 dang chay - no ghi de toan bo prefs khi thoat,"
  echo "       nen 'defaults write' luc nay se bi mat trang."
  echo "       Cach 1: Settings > Profiles > Deep Harbor > Other Actions > Set as Default"
  echo "       Cach 2: thoat han iTerm2 (Cmd+Q) roi chay lai script nay"
else
  defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "$GUID"
  echo "    xong"
fi

cat <<'EOF'

==> Buoc cuoi, lam trong Claude Code (khong tu dong hoa duoc):

    /config  ->  Theme  ->  Dark mode (ANSI colors only)

    Bat buoc. Neu de theme "dark", Claude Code phat mau RGB tuyet doi
    va bo qua toan bo palette cua terminal.
    Dau hieu da dung: inline code chuyen tu tim sang xanh.

EOF
