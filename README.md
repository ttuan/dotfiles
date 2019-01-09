# Dotfiles

```
                                       _       _    __ _ _
                                      | |     | |  / _(_) |
                                    __| | ___ | |_| |_ _| | ___  ___
                                   / _` |/ _ \| __|  _| | |/ _ \/ __|
                                  | (_| | (_) | |_| | | | |  __/\__ \
                                   \__,_|\___/ \__|_| |_|_|\___||___/

```

> You’re The King Of Your Castle!

# What are in this repo

This repo contains all my dotfiles.

```sh
.
├── ctags
│   └── ctags
├── fish
│   └── config.fish
├── git
│   ├── gitconfig
│   └── gitignore
├── i3
│   ├── config
│   └── i3status.conf
├── install.sh
├── mac_install.zsh
├── rails
│   ├── gemrc
│   ├── irbrc
│   ├── pryrc
│   └── railsrc
├── README.md
├── scripts
│   ├── getSongName.sh
│   ├── install-adblock-host
│   ├── refresh_firefox.sh
│   └── Xmodmap
├── sync.sh
├── tmux
│   ├── safekill.sh
│   └── tmux.conf
├── tmuxinator
│   └── project.yml
├── vim
│   ├── ackrc
│   └── vimrc
├── vimperator
│   ├── plugin
│   │   └── YoutubePlayer - Copy.js
│   └── vimperatorrc
├── vps_setup.sh
└── zsh
    ├── alias.zsh
    ├── fzf.zsh
    ├── zshenv
    └── zshrc
```

# Requirements

Set zsh as a login shell:

```sh
chsh -s $(which zsh)
```

# Installation

```
git clone https://github.com/ttuan/dotfiles.git ~/dotfiles
cd dotfiles
chmod +x install.sh
./install.sh
```
