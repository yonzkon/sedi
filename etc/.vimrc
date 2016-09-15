" .vimrc

" identify platform
function OSX()
	return has('macunix')
endfunction
function LINUX()
	return has('unix') && !has('macunix') && !has('win32unix')
endfunction
function WINDOWS()
	return (has('win16') || has('win32') || has('win64'))
endfunction

" basics
set nocompatible " Must be first line
filetype off     " required

" windows compatible
if WINDOWS()
	set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif


" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'molokai'
Plugin 'a.vim'

Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
"Plugin 'fholgado/minibufexpl.vim'

"Plugin 'scrooloose/syntastic'
Plugin 'Valloric/ListToggle'
Plugin 'Valloric/YouCompleteMe'

"Plugin 'SirVer/ultisnips'
"Plugin 'nathanaelkane/vim-indent-guides'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
"Plugin 'user/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


set laststatus=2 "always show the status bar
set ruler
set number
set cursorline
set cursorcolumn
set hlsearch
set nowrap

syntax on "use syntax highlight other than default one
filetype indent on "auto indent between different languages or filetypes
colorscheme solarized
set background=dark
if (strftime("%H") >= 8 && strftime("%H") < 18)
    set background=light
endif

" tab & indent & fold & search
"set expandtab
set smarttab
set tabstop=4     "for tab
set shiftwidth=4  "for indent
set softtabstop=4 "for mix space and tab
set autoindent
set smartindent
set foldmethod=syntax
"set foldlevel=2
set foldcolumn=0
set nofoldenable
set ignorecase
set smartcase

" file & directory
set autochdir
set fileformats=unix,dos,mac
set nobackup nowritebackup noswapfile
set encoding=utf8
set termencoding=utf8
set fileencodings=utf8,gbk
set list "list & listchars that copied from spf13 and should be added after 'set encoding=utf8'
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
"set listchars=tab:\ \ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
set backspace=eol,start,indent
set spell spelllang=en_us
set nospell
set helplang=cn

" for c/c++ code
set tags=./tags,/usr/include/tags
set path+=./include


" leader
let mapleader=','
nmap <leader>, :!
nmap <leader>h :h<space>
" switch between .h and .cpp file
nmap <Leader>a :A<cr>
" open new child window for display .h or .cpp file
nmap <Leader>as :AS<cr>

" buffer & nerdtree & tagbar
nmap <C-l><C-l> :ls<cr>:b
nmap <C-l><C-d> :bd<cr>
nmap <C-l><C-u> :bun<cr>
let tagbar_width=30
nmap <C-t> :TagbarToggle<cr>
let NERDTreeWinSize=30
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeAutoDeleteBuffer=1
nmap <C-e> :NERDTreeToggle<cr>

" ctrlp
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.o,*.a,*.so,*.swp
set wildignore+=*.tar*,*.zip,*.rar
set wildignore+=*.pdf,*.doc,*.docx
"let ctrlp_by_filename=1
"let ctrlp_regexp=1
"let ctrlp_show_hidden=1
"let ctrlp_custom_ignore='\.(cache|config|ssh)$'
nmap <leader>pp :CtrlP<cr>
nmap <leader>pd :CtrlP<space>
nmap <leader>pb :CtrlPBuffer<cr>
nmap <leader>pm :CtrlPMRU<cr>
nmap <leader>pl :CtrlPLastMode<cr>
nmap <leader>pr :CtrlPRoot<cr>

" youcompleteme
set completeopt=longest,menu
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up> pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp> pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
let ycm_global_ycm_extra_conf='~/.ycm_extra_conf.py'
let ycm_confirm_extra_conf=0
let syntastic_always_populate_loc_list=1
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>jr :YcmCompleter GoToReferences<CR>

" terminal / gvim
if !has("gui_running")
	colorscheme molokai
	set t_Co=256
	hi MatchParen ctermfg=white ctermbg=black
	hi Comment ctermfg=brown cterm=bold
	hi Folded ctermfg=darkgrey ctermbg=none cterm=bold
else
	set lines=38
	set columns=118
	" prohibit cursor blinking
	set gcr=a:block-blinkon0
	" prohibit to show scrollbar
	set guioptions-=l
	set guioptions-=L
	set guioptions-=r
	set guioptions-=R
	set guioptions-=b
	" prohibit to show menu & toolbar
	set guioptions-=m
	set guioptions-=T
	if !WINDOWS()
		set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
	else
	    set guifont=Consolas:h11
	endif
endif
