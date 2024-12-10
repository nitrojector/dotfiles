
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



" Turn on syntax highlighting
syntax enable
" colorscheme monokai
colorscheme monokai-pro
"hi Normal guibg=NONE ctermbg=NONE
hi NonText ctermfg=60 guifg=#AE81FF

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
inoremap <C-c> <Esc>

" SQL autocomplete is C-c??
let g:ftplugin_sql_omni_key = '<C-j>'

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

" Paste from copy register
nnoremap <silent> <leader>p "0p

" Show difference between buffer and file
nnoremap <silent> <leader>d :w !diff % -<CR>

" This is totally awesome - remap jj to escape in insert mode.	You'll never type jj anyway, so it's great!
inoremap jj <Esc>

" Save and run code
nnoremap <leader>b :w<CR>:!./build.sh<CR>
nnoremap <leader>ctex :w<CR>:!pdflatex -synctex=1 -interaction=nonstopmode "%:t"<CR>
nnoremap <leader>cp :w<CR>:!python %<CR>
nnoremap <leader>cn :w<CR>:!node %<CR>
nnoremap <leader>cj :w<CR>:!javac %<CR>:!java -cp %:p:h %:t:r<CR>
nnoremap <leader>cc :w<CR>:!g++ -g % -o %:r<CR>:!./%:r<CR>
nnoremap <leader>ctt :w<CR>:silent !python /home/takina/scripts/cleantodo.py -f<CR>

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
	return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
	let l:branchname = GitBranch()
	return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction


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
set statusline+=\ ▸\ %Y											 " Language
set statusline+=\ [%4l/%L,%4v]\ %p%\% "Line, column, percentage
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
nnoremap <CR> :let @/ = ""<CR>

" Convert to and from xxd (hex)
nnoremap <leader>h :call ToggleHex()<CR>

" Visualize tabs and newlines
set listchars=tab:⇒\ ,eol:¬
" Uncomment this to enable by default:
" set list " To enable by default
" Or use your leader key + l to toggle on/off
map <leader>l :set list!<CR> " Toggle tabs and EOL

