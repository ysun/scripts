runtime! debian.vim


set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
"set rtp+=/etc/vim/bundle/Vundle.vim
set rtp+=/etc/vim/bundle/vundle
call vundle#begin()
"call vundle#rc()
" alternatively, pass a path where Vundle should install plugins

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Bundle 'gmarik/vundle'
Bundle 'Valloric/YouCompleteMe'
Bundle 'scrooloose/syntastic'
Bundle 'rdnetto/YCM-Generator'

"Plugin 'tpope/vim-fugitive'
"Plugin 'Lokaltog/vim-easymotion'
"Plugin 'tpope/vim-rails.git'
"" The sparkup vim script is in a subdirectory of this repo called vim.
"" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
"" scripts from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
"Plugin 'FuzzyFinder'
" scripts not on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'


" " The following are examples of different formats supported.
" " Keep Plugin commands between vundle#begin/end.
" " plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" " plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" " Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" " git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" " The sparkup vim script is in a subdirectory of this repo called vim.
" " Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" " Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

let mapleader = ","  " 这个leader就映射为逗号“，”
" let g:ycm_global_ycm_extra_conf = '/etc/vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'   "配置默认的ycm_extra_conf.py
let g:ycm_global_ycm_extra_conf = '/etc/vim/bundle/YouCompleteMe/ycm_extra_conf.py'   "configure for linux kernel
let g:ycm_auto_trigger = 1

let g:ycm_show_diagnostics_ui = 0

nnoremap <leader>jl :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>jf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>jg :YcmCompleter GoToDefinitionElseDeclaration<CR> "按,jg 会跳转到

nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>

" 允许 vim 加载 .ycm_extra_conf.py 文件，不再提示
"let g:ycm_confirm_extra_conf=0    "打开vim时不再询问是否加载ycm_extra_conf.py配置
let g:ycm_collect_identifiers_from_tag_files = 1 "使用ctags生成的tags文件

" YouCompleteMe 功能
" 补全功能在注释中同样有效
let g:ycm_complete_in_comments=1
" 开启 YCM 基于标签引擎
let g:ycm_collect_identifiers_from_tags_files=1

"引入 C++
"标准库tags，这个没有也没关系，只要.ycm_extra_conf.py文件中指定了正确的标准库路径
set tags+=/data/misc/software/misc./vim/stdcpp.tags
" YCM 集成 OmniCppComplete 补全引擎，设置其快捷键
"inoremap <leader>; <C-x><C-o>
" 补全内容不以分割子窗口形式出现，只显示补全列表
set completeopt-=preview
" 从第一个键入字符就开始罗列匹配项
let g:ycm_min_num_of_chars_for_completion=1
" 禁止缓存匹配项，每次都重新生成匹配项
let g:ycm_cache_omnifunc=0
" 语法关键字补全           
let g:ycm_seed_identifiers_with_syntax=1
" 修改对C函数的补全快捷键，默认是CTRL + space，修改为ALT + ;
let g:ycm_key_invoke_completion = '<M-;>'
" 设置转到定义处的快捷键为ALT + G，这个功能非常赞
"nmap <M-g> :YcmCompleter GoToDefinitionElseDeclaration <C-R>=expand("<cword>")<CR><CR>


" ----- scrooloose/syntastic settings -----
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"
augroup mySyntastic
  au!
  au FileType tex let b:syntastic_mode = "passive"
augroup END

colorscheme desert

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
"runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
"if has("autocmd")
"  filetype plugin indent on
"endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
"set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" cs add /home/xen/linux-vgt/cscope.out

set ut=10        " refresh occurs every second;
set hlsearch
set tags=tags;    "   其中 ; 不能没有
set autochdir

function! AutoLoadCTagsAndCScope()
    let max = 7
    let dir = './'
    let i = 0
    let break = 0
    while isdirectory(dir) && i < max
        if filereadable(dir . 'cscope.out') 
            execute 'cs add ' . dir . 'cscope.out'
            let break = 1
        endif
"         if filereadable(dir . 'tags')
"             execute 'set tags =' . dir . 'tags'
"             let break = 1
"         endif
        if break == 1
            execute 'lcd ' . dir
            break
        endif
        let dir = dir . '../'
        let i = i + 1
    endwhile
    return break
endf

if filereadable("cscope.out") 
    cs add cscope.out 
else
    let ret = AutoLoadCTagsAndCScope()
    if ret  == 0
        cs add /home/xen/linux-vgt/cscope.out
    endif
endif 

if has("cscope")
	set cscopetag   " 使支持用 Ctrl+]  和 Ctrl+t 快捷键在代码间跳来跳去
	" check cscope for definition of a symbol before checking ctags:
	" set to 1 if you want the reverse search order.
	 set csto=1
	
	 " add any cscope database in current directory
	 " if filereadable("cscope.out")
	 "    cs add cscope.out
	 " else add the database pointed to by environment variable
	 " elseif $CSCOPE_DB !=""
	 "    cs add $CSCOPE_DB
	 " endif
	
	 " show msg when any other cscope db added
	 set cscopeverbose
	
	 nmap <C-j>s :cs find s <C-R>=expand("<cword>")<CR><CR>
	 nmap <C-j>g :cs find g <C-R>=expand("<cword>")<CR><CR>
	 nmap <C-j>c :cs find c <C-R>=expand("<cword>")<CR><CR>
	 nmap <C-j>t :cs find t <C-R>=expand("<cword>")<CR><CR>
	 nmap <C-j>e :cs find e <C-R>=expand("<cword>")<CR><CR>
	 nmap <C-j>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
	 nmap <C-j>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
	 nmap <C-j>d :cs find d <C-R>=expand("<cword>")<CR><CR>
"	 if has('quickfix')
"		 set cscopequickfix=s-,c-,d-,i-,t-,e-
"	 endif
endif

"set cscopequickfix=s-,c-,d-,i-,t-,e-,g-,f-
set cscopequickfix=s-!,c-!,d-!,i-!,t-!,e-!,g-!,f-!
"nnoremap <silent> <F9> :copen<CR><CR>
"https://github.com/milkypostman/vim-togglelist
nmap <script> <silent> <F9> :call ToggleQuickfixList()<CR>
copen

let Cscope_OpenQuickfixWindow = 1 	"执行cscope cmd后打开quickfix window"
let Cscope_JumpError = 0 			"跳转到first item"
let Cscope_PopupMenu = 1 			"use Popup menu"
let Cscope_ToolsMenu = 0			"use Tools menu"

" 按F8按钮，在窗口的左侧出现taglist的窗口,像vc的左侧的workpace
nnoremap <silent> <F8> :TlistToggle<CR><CR>
let Tlist_Show_One_File=0                    " 只显示当前文件的tags
let Tlist_Exit_OnlyWindow=1                  " 如果Taglist窗口是最后一个窗口则退出Vim
let Tlist_Use_Right_Window=0                 " 在右侧窗口中显示
let Tlist_File_Fold_Auto_Close=1             " 自动折叠
let Tlist_Auto_Open = 1

