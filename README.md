# Dotfiles

![](https://i.imgur.com/hqazHhc.png)

```
      _       _    __ _ _
     | |     | |  / _(_) |
   __| | ___ | |_| |_ _| | ___
  / _` |/ _ \| __|  _| | |/ _ \
 | (_| | (_) | |_| | | | |  __/
  \__,_|\___/ \__|_| |_|_|\___|

```

> You’re The King Of Your Castle!

# What are in this repo

This repo contains all my dotfile.

```sh
.
├── README.md
├── _site
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
├── irb
├── mac_install.zsh
├── rails
│   ├── gemrc
│   ├── irbrc
│   └── railsrc
├── scripts
│   ├── Xmodmap
│   ├── getSongName.sh
│   ├── install-adblock-host
│   └── refresh_firefox.sh
├── server_install_script.sh
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
│   │   └── YoutubePlayer\ -\ Copy.js
│   └── vimperatorrc
└── zsh
    ├── alias.zsh
    ├── fzf.zsh
    └── zshrc
```

# Requirements

Set zsh as a login shell:

```sh
chsh -s $(which zsh)
```

# Installation

```
git clone https://github.com/ttuan/dotfile.git ~/dotfile
cd dotfile
chmod +x install.sh
./install.sh
```
