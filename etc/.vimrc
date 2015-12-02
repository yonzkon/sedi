
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
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

Plugin 'scrooloose/syntastic'
Plugin 'Valloric/ListToggle'
"Plugin 'Valloric/YouCompleteMe'

Plugin 'SirVer/ultisnips'
Plugin 'nathanaelkane/vim-indent-guides'

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


let mapleader=','
map <leader>x :!
map <leader>mm :!make<cr>
map <leader>mc :!make && make clean<cr>
map <leader>mi :!make install<cr>
map <leader>mx :!make exec<cr>

let g:ctrlp_map = '<leader>p'
let g:ctrlp_cmd = 'CtrlP'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip    "MacOSX/Linux"
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$\|.rvm$'
let g:ctrlp_working_path_mode=0
let g:ctrlp_match_window_bottom=1

map <Leader>b :buffers<cr>
map <Leader>e :NERDTreeToggle<cr>
map <Leader>t :TagbarToggle<cr>
let tagbar_width=30
let NERDTreeWinSize=24
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeAutoDeleteBuffer=1
map <C-h> :bp<cr>
map <C-l> :bn<cr>

syntax enable
colorscheme solarized
if (strftime("%H") >= 8 && strftime("%H") < 18)
    set background=light
else
    set background=dark
endif

if (has("win32") || has("win64") || has("win95") || has("win16"))
endif
if has("gui_running")
    " 设置行列数
    set lines=45
    set columns=160
    " 禁止光标闪烁
    set gcr=a:block-blinkon0
    " 禁止显示滚动条
    set guioptions-=l
    set guioptions-=L
    set guioptions-=r
    set guioptions-=R
    set guioptions-=b
    " 禁止显示菜单工具条
    set guioptions-=m
    set guioptions-=T
    " 设置字体
    "set guifont=Consolas:h12
else
    colorscheme molokai
endif

" 总是显示状态栏
set laststatus=2
" 显示光标当前位置
set ruler
" 开启行号显示
set number
" 高亮显示当前行/列
set cursorline
set cursorcolumn
" 高亮显示搜索结果
set hlsearch
" 禁止折行
set nowrap

" 允许用指定语法高亮配色方案替换默认方案
syntax on
" 自适应不同语言的智能缩进
filetype indent on
" 将制表符扩展为空格
set expandtab
" 设置编辑时制表符占用空格数
set tabstop=4
" 设置格式化时制表符占用空格数
set shiftwidth=4
" 让vim把连续数量的空格视为一个制表符
set softtabstop=4

" 随vim自启动
let g:indent_guides_enable_on_vim_startup=1
" 从第二层开始可视化显示缩进
let g:indent_guides_start_level=2
" 色快宽度
let g:indent_guides_guide_size=1

" 基于缩进或语法进行代码折叠
"set foldmethod=indent
set foldmethod=syntax
" 启动vim时关闭折叠代码
set nofoldenable

" *.cpp和*.h间切换
nmap <Leader>ch :A<cr>
" 子窗口中显示*.cpp或*.h
nmap <Leader>sch :AS<cr>


" filetype plugin indent on
set fileformats=unix,dos,mac
set nobackup nowritebackup noswapfile
set encoding=utf8
set termencoding=utf8
set fileencodings=utf8,gbk
set backspace=eol,start,indent
set smarttab
set autoindent smartindent
"set foldlevel=2
set foldcolumn=0
set autochdir
set tags=./tags,/usr/include/tags
set path=/home/munie/src/kernel/linux-stable/include,.,/usr/include,,
set helplang=cn

"set t_Co=256
"hi MatchParen ctermfg=white ctermbg=black
"hi Comment ctermfg=brown cterm=bold
"hi Folded ctermfg=darkgrey ctermbg=none cterm=bold
