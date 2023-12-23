" Emmet
imap <C-j> <C-y>,

" Commentary
map cm gc

" AutoSave
let g:auto_save = 1
let g:auto_save_silent = 1
let g:auto_save_in_insert_mode = 1

" Python mode
let g:pymode_options_max_line_length = 120
let g:pymode_lint_options_pep8 = {'max_line_length': g:pymode_options_max_line_length}
let g:pymode_options_colorcolumn = 1

" Translate
let g:translator_target_lang = 'en'
let g:translator_default_engines = ['google']
vmap <silent> <Leader>t <Plug>TranslateWV
