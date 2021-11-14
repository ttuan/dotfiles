" Sections:
"    -> General
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers
"    -> Status line
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Spell checking
"    -> Misc
"    -> Helper functions
"

"==========================================================
"\\ General
"==========================================================
set history=10000                                   " Set command line history limit


"==========================================================
"\\ VIM user interface
"==========================================================
set number                                          " Line number are good
set relativenumber                                  " Relative number to quickly run command

set incsearch                                       " Find the next match as we type the search
set hlsearch                                        " Highlight searches by default
set ignorecase                                      " Search case insensitive
set smartcase                                       " But not when contain a uppercase char


"==========================================================
"\\ Colors and Fonts
"==========================================================
colorscheme gruvbox
set background=dark

"==========================================================
