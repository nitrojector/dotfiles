" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" Restore cursor position to where it was before
augroup JumpCursorOnEdit
	au!
	autocmd BufReadPost *
				\ if expand("<afile>:p:h") !=? $TEMP |
				\	if line("'\"") > 1 && line("'\"") <= line("$") |
				\	  let JumpCursorOnEdit_foo = line("'\"") |
				\	  let b:doopenfold = 1 |
				\	  if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
				\		 let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
				\		 let b:doopenfold = 2 |
				\	  endif |
				\	  exe JumpCursorOnEdit_foo |
				\	endif |
				\ endif
	" Need to postpone using "zv" until after reading the modelines.
	autocmd BufWinEnter *
				\ if exists("b:doopenfold") |
				\	exe "normal zv" |
				\	if(b:doopenfold > 1) |
				\		exe  "+".1 |
				\	endif |
				\	unlet b:doopenfold |
				\ endif
augroup END

" Don't try to be vi compatible
set nocompatible

" change leader key to space
map <Space> <Nop>
let mapleader = " "

" Helps force plugins to load correctly when it is turned back on below
filetype off

"VSCODE_UNSUPPORTED_BEGIN
" [PLUGINS] vim-plug
call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'github/copilot.vim'
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'loctvl842/monokai-pro.nvim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'christoomey/vim-tmux-navigator'
Plug 'neovim/nvim-lspconfig'
Plug 'mhartington/formatter.nvim'
Plug 'stevearc/conform.nvim'
Plug 'folke/trouble.nvim'
" Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'

call plug#end()

" Plugin Shortcuts

" GitHub Copilot
" imap <silent> <C-j> <Plug>(copilot-next)
" imap <silent> <C-k> <Plug>(copilot-prev) " Disabled b/c conflict with

" vim-tmux-navigator
nnoremap <silent> <leader>t :NERDTreeToggle<CR>
" nnoremap <silent> <leader>o :tabe<CR>:Files<CR> " Apparently I don't need this, just use C-t with :Files
nnoremap <silent> <leader>f :Files<CR>
"VSCODE_UNSUPPORTED_END


" Turn on syntax highlighting
syntax on

" Auto Reload
set autoread

" Toggle spellchecking
function! ToggleSpellCheck()
	set spell!
	if &spell
		echo "Spellcheck ON"
	else
		echo "Spellcheck OFF"
	endif
endfunction

nnoremap <silent> <leader>s :call ToggleSpellCheck()<CR>

" Create Blank Newlines and stay in Normal mode
nnoremap <silent> zj :set paste<CR>o<Esc>:set nopaste<CR>
nnoremap <silent> zk :set paste<CR>O<Esc>:set nopaste<CR>

" Use ctrl-[hjkl] to select the active split!
" nnoremap <silent> <c-k> :wincmd k<CR>
" nnoremap <silent> <c-j> :wincmd j<CR>
" nnoremap <silent> <c-h> :wincmd h<CR>
" nnoremap <silent> <c-l> :wincmd l<CR>

" Split windows on the right
set splitright
set splitbelow

" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

" Go to last active tab
au TabLeave * let g:lasttab = tabpagenr()
nnoremap <silent> <leader>l :exe "tabn ".g:lasttab<cr>
vnoremap <silent> <leader>l :exe "tabn ".g:lasttab<cr>

" Make <C-c> behave like <Esc>
imap <C-c> <Esc>

" New Tab
nnoremap <silent> <C-t> :tabnew<CR>

" Edit vimrc \rc
nnoremap <silent> <leader>rc :tabnew ~/.vimrc<CR>
nnoremap <silent> <leader>rl :tabnew ~/.config/nvim/init.lua<CR>

" Yank to system register
nnoremap <leader>y :"+yy<CR>
xnoremap <leader>y :y+<CR>

" Paste and delete _ register
xnoremap <silent> <leader>p "_dP

" Show difference between buffer and file
nnoremap <silent> <leader>d :w !diff % -<CR>

" This is totally awesome - remap jj to escape in insert mode.	You'll never type jj anyway, so it's great!
inoremap jj <Esc>

" Save and run code
nnoremap <leader>ctex :w<CR>:!pdflatex -synctex=1 -interaction=nonstopmode "%:t"<CR>
nnoremap <leader>cp :w<CR>:!python %<CR>
nnoremap <leader>cn :w<CR>:!node %<CR>
nnoremap <leader>cj :w<CR>:!javac %<CR>:!java -cp %:p:h %:t:r<CR>
nnoremap <leader>cc :w<CR>:!g++ -g % -o %:r<CR>:!./%:r<CR>
" nnoremap <leader>ctt :w<CR>:silent !python /home/takina/scripts/cleantodo.py -f<CR>

" For plugins to load correctly
filetype plugin indent on

" Security
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

" Whitespace
set wrap

set textwidth=0
set formatoptions=tcqrn1
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab
set noshiftround

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines (even when wrapped)
nnoremap <silent> k gk
nnoremap <silent> j gj
" cnoremap <silent> k gk
" cnoremap <silent> j gj
inoremap <silent> <Up> <Esc>gka
inoremap <silent> <Down> <Esc>gja

" When I close a tab, remove the buffer
set nohidden

" Rendering
set ttyfast

" Git Function

function! GitBranch()
	return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
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
set statusline+=\ ▸\ %Y											 " Language
set statusline+=(%{&fileencoding?&fileencoding:&encoding}) " File encoding
" set statusline+=\ %1*\ %0*\ [%4l,%4v]						  " Line and column
set statusline+=\ ▸\ [%4l,%4v]						  " Line and column
set statusline+=\ ▸\ %p%\%										   " Percentage of file at current position
set statusline+=\ %1*\ 柒\ "								" Custom character

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
nnoremap <CR> :let @/ = ""<CR>

" Convert to and from xxd (hex)
nnoremap <leader>h :%!xxd<CR>
nnoremap <leader>g :%!xxd -r<CR>

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
" Uncomment this to enable by default:
" set list " To enable by default
" Or use your leader key + l to toggle on/off
map <leader>l :set list!<CR> " Toggle tabs and EOL

