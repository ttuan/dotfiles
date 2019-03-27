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

These are the various configuration files I use on Ubuntu and macOS.

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
├── install
├── install.conf.yaml
├── rails
│   ├── gemrc
│   ├── irbrc
│   ├── pryrc
│   └── railsrc
├── README.md
├── scripts
│   ├── getSongName.sh
│   ├── install-adblock-host
│   ├── mac_install.zsh
│   ├── refresh_firefox.sh
│   ├── sync.sh
│   ├── ubuntu_install.sh
│   ├── vps_setup.sh
│   └── Xmodmap
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
└── zsh
    ├── alias.zsh
    ├── fzf.zsh
    ├── zshenv
    └── zshrc
```

# Install

```
git clone https://github.com/ttuan/dotfiles.git ~/dotfiles
cd dotfiles
```

* For fresh install: `script/install.sh`
* For sync dotfiles only: `./install` (Thank for [dotbot](https://github.com/anishathalye/dotbot))
