" Don't try to be vi compatible
set nocompatible

" change leader key to space
map <Space> <Nop>
let mapleader = " "

" Helps force plugins to load correctly when it is turned back on below
" filetype off

"VSCODE_UNSUPPORTED_BEGIN
" [PLUGINS] vim-plug
call plug#begin()

" fzf-lua

Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
Plug 'nvim-tree/nvim-web-devicons'

Plug 'loctvl842/monokai-pro.nvim'

Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

call plug#end()

" Plugin Shortcuts

" GitHub Copilot
" imap <silent> <C-j> <Plug>(copilot-next)
" imap <silent> <C-k> <Plug>(copilot-prev) " Disabled b/c conflict with

"VSCODE_UNSUPPORTED_END


" Turn on syntax highlighting
syntax enable
" colorscheme monokai
colorscheme monokai-pro
" hi Normal guibg=NONE ctermbg=NONE
hi NonText ctermfg=60 guifg=#AE81FF

" Make <C-c> behave like <Esc>
inoremap <C-c> <Esc>

" Paste and delete _ register
xnoremap <silent> <leader>p "_dP

" Paste from copy register
nnoremap <silent> <leader>p "0p

" Show difference between buffer and file
nnoremap <silent> <leader>d :w !diff % -<CR>

" This is totally awesome - remap jj to escape in insert mode.	You'll never type jj anyway, so it's great!
inoremap jj <Esc>


" For plugins to load correctly
filetype plugin indent on

set modelines=0

" Show line numbers
set number
set relativenumber

" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
set visualbell

" Yes, unicode!
set encoding=utf-8

" Cool tab completion stuff
set wildmenu
set wildmode=list:longest,full

" wrap
set wrap
set breakindent
let &showbreak='↪'
" set cpo+=n


set textwidth=0
set formatoptions=tcqrn1
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab
set noshiftround

" Show color column at 80 characters
set colorcolumn=80

" mks and quit all
command! Q mksession! | qa

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines (even when wrapped)
" nnoremap <silent> k gk
" nnoremap <silent> j gj
" cnoremap <silent> k gk
" cnoremap <silent> j gj
inoremap <silent> <Up> <Esc>gka
inoremap <silent> <Down> <Esc>gja

set nohidden

" Rendering
set ttyfast

" Git Function

function! GitBranch()
	if !executable('git')
		return ''
	endif
	let l:br = ''
	if has('win32') || has('win64')
		let l:br = system("git rev-parse --abbrev-ref HEAD 2>NUL")
	else
		let l:br = system("git rev-parse --abbrev-ref HEAD 2>/dev/null")
	endif
	let l:br = substitute(l:br, "\n", "", "")
	return l:br
endfunction

function! StatuslineGit()
	let l:branchname = GitBranch()
	return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

"VSCODE_UNSUPPORTED_BEGIN
" Special rules for <CR> (macro expansion)
function! NLSP()
	let l:line = getline('.')
	let l:col = col('.') - 1

	" If cursor within {} then auto place
	if l:col > 0 && l:col < len(l:line) && l:line[l:col - 1] == '{' && l:line[l:col] == '}'
		call feedkeys("\<CR>\<c-o>O", 'n')
	else
		call feedkeys("\<CR>", 'n')
	endif
endfunction


inoremap <CR> <C-o>:call NLSP()<CR>
"VSCODE_UNSUPPORTED_END

" Status bar
set laststatus=2
set statusline=
set statusline+=%1*%{StatuslineGit()}						  " Git branch statusline
" set statusline+=%0*\ %2{mode()}>								   " Mode
" set statusline+=%0*\ %<%t\ %m%r%h%w						  " File name only
set statusline+=%0*\ %f\ %m%r%h%w							  " File name with full path
" set statusline+=%=%1*\ %0*\ %{&ff}							" Platform
set statusline+=%=\ %{&ff}							" Platform
"set statusline+=\ ▸\ %Y											 " Language
set statusline+=(%{&fileencoding?&fileencoding:&encoding}) " File encoding
set statusline+=\ %Y											 " Language
set statusline+=\ [%4l/%L,%4v]\ %3p%\% "Line, column, percentage
"set statusline+=\ %1*\ ○\ "
set statusline+=\ ○\ "

" Last line
set showmode
set showcmd

" Searching *
" nnoremap / /\v
" vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
map N Nzz
map n nzz

" Scrolling -- center cursor, makes it so much easier to track
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Clear serach with Enter
nnoremap <leader><CR> :let @/ = ""<CR>

" Visualize tabs and newlines
set listchars=tab:⇒\ ,eol:¬
" Uncomment this to enable by default:
" set list " To enable by default
" Or use your leader key + l to toggle on/off
map <leader>l :set list!<CR> " Toggle tabs and EOL

