" put this line first in ~/.vimrc
set nocompatible | filetype indent plugin on | syn on

fun! SetupVAM()
    let c = get(g:, 'vim_addon_manager', {})
    let g:vim_addon_manager = c
    let c.plugin_root_dir = expand('$HOME', 1) . '/.vim/bundle'

    " Force your ~/.vim/after directory to be last in &rtp always:
    " let g:vim_addon_manager.rtp_list_hook = 'vam#ForceUsersAfterDirectoriesToBeLast'

    " most used options you may want to use:
    " let c.log_to_buf = 1
    " let c.auto_install = 0
    let &rtp.=(empty(&rtp)?'':',').c.plugin_root_dir.'/vim-addon-manager'
    if !isdirectory(c.plugin_root_dir.'/vim-addon-manager/autoload')
    execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '
        \       shellescape(c.plugin_root_dir.'/vim-addon-manager', 1)
    endif

    " This provides the VAMActivate command, you could be passing plugin names, too
    call vam#ActivateAddons([], {})
endfun
call SetupVAM()

call system('wmctrl -i -b add,maximized_vert,maximized_horz -r '.v:windowid)

" ACTIVATING PLUGINS
"ActivateAddons lh-brackets

call plug#begin('~/.vim/bundle')

Plug 'joshdick/onedark.vim'
let g:onedark_termcolors=16
Plug 'psf/black', { 'branch': 'stable' }
"Plug 'wfxr/minimap.vim'
"Plug 'inkarkat/vim-DeleteTrailingWhitespace'
Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java'}
"Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
"Plug 'SirVer/ultisnips'
"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'w0rp/ale'
Plug 'ctrlpvim/ctrlp.vim'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'timburgess/extempore.vim'
"Plug 'dermusikman/sonicpi.vim'

call plug#end()

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
    set termguicolors
endif
endif

"Minimap settings {{{
"let g:minimap_auto_start = 1
"let g:minimap_block_filetypes = ['fugitive', 'nerdtree', 'tagbar']
"let g:minimap_block_buftypes = ['nofile', 'nowrite', 'quickfix', 'terminal', 'prompt']
"}}}

"Ctrlp Settings {{{

let g:ctrlp_map = '<c-p>'

let g:ctrlp_cmd = 'ctrlp'
let g:ctrlp_dont_split = 'nerd'
let g:ctrlp_working_path_mode = 'rw'
set wildignore+=*/.git/*,*/tmp/*,*.swp/*,*/node_modules/*,*/temp/*,*/Builds/*,*/ProjectSettings/*
" Set no max file limit
let g:ctrlp_max_files = 0
" Search from current directory instead of project root


function! CtrlPCommand()
  let c = 0
  let wincount = winnr('$')
  " Don't open it here if current buffer is not writable (e.g. NERDTree)
  while !empty(getbufvar(+expand("<abuf>"), "&buftype")) && c < wincount
    exec 'wincmd w'
    let c = c + 1
  endwhile
  exec 'CtrlP'
endfunction
let g:ctrlp_cmd = 'call CtrlPCommand()'

"RipGrep
if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif
let g:ctrlp_custom_ignore = {
      \ 'dir':  '',
      \ 'file': '\.so$\|\.dat$|\.DS_Store$|\.meta|\.zip|\.rar|\.ipa|\.apk',
      \ }
" }}}
"Ale Settings {{{

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_open_list = 0
let g:ale_loclist = 0
"g:ale_javascript_eslint_use_global = 1
let g:ale_linters = {
      \  'cs':['syntax', 'semantic', 'issues'],
      \  'python': ['black', 'pylint'],
      \  'java': ['javac']
      \ }
" }}}

autocmd BufWritePre,TextChanged,InsertLeave *.py Black

" UltiSnips {{{

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
"let g:UltiSnipsExpandTrigger="<c-j>"
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
"let g:UltiSnipsEditSplit="vertical"

"let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']
"let g:UltiSnipsSnippetsDir="~/.vim/UltiSnips"

" }}}

" Java {{{

" Easy compile java in vim
autocmd FileType java set makeprg=javac\ %
set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C.%#
" Java completion
autocmd FileType java setlocal omnifunc=javacomplete#Complete
autocmd FileType java JCEnable
" }}}

command Muse execute "!sh -c $HOME/.local/bin/extempore"

" switch colon and semi-colon
nnoremap ; :
nnoremap : ;

" block insert bracket
vnoremap  (  s()<Esc>P<Right>
vnoremap  [  s[]<Esc>P<Right>
vnoremap  {  s{}<Esc>P<Right>
vnoremap  "  s""<Esc>P<Right>
vnoremap  '  s''<Esc>P<Right>

" auto complete (), [], {}, "", ''
inoremap ( ()<left>
inoremap (( (
inoremap () ()
inoremap [ []<left>
inoremap [[ [
inoremap [] []
inoremap { {}<left>
inoremap {{ {
inoremap {} {}
inoremap " ""<left>
inoremap "" ""
inoremap ' ''<left>
inoremap '' ''

" autocomplete
fun! CleverComplete()
  if pumvisible()
    return "\<C-n>"
  endif
  if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
    return "\<Tab>"
  elseif exists('&omnifunc') && &omnifunc != ''
    return "\<C-X>\<C-O>\<C-n>"
  else
    return "\<C-n>\<C-n>"
  endif
endfun

inoremap <expr> <Tab>  CleverComplete()
inoremap <expr> <BS>   pumvisible() ? "\<ESC>a\<BS>" : "\<BS>"
"inoremap <expr> <CR>   pumvisible() ? asyncomplete#close_popup() : "\<cr>"

" vim stuff
set lazyredraw
set noswapfile
set number
set tabstop=4
set shiftwidth=4
set expandtab
set omnifunc=syntaxcomplete#Complete
set completeopt=longest,noinsert,menuone
set colorcolumn=80
highlight ColorColumn ctermbg=7

" sonic-pi
"let g:sonicpi_enabled = 1
"let g:sonicpi_command = 'sonic-pi-tool'
"let g:sonicpi_send = 'eval-stdin'
"let g:sonicpi_stop = 'stop'

" vim stuff
let g:vim_redraw = 1
let g:black_linelength=80
let g:onedark_hide_endofbuffer=1
let g:airline_theme='onedark'

syntax on
colorscheme onedark

