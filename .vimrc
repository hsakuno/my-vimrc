" release autogroup in MyAutoCmd
augroup MyAutoCmd
	autocmd!
augroup END

syntax on
colorscheme zenburn
set t_Co=256
set ruler
set title
set wildmenu
set showcmd
set hlsearch
set autoindent
set tabstop=4
set shiftwidth=4
set smarttab
" 0埋めされた数字も10進数としてインクリメント
set nf=

""" 検索関係
set ignorecase          " 大文字小文字を区別しない
set smartcase           " 検索文字に大文字がある場合は大文字小文字を区別
set incsearch           " インクリメンタルサーチ
set hlsearch            " 検索マッチテキストをハイライト

"""編集関係
set shiftround          " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set infercase           " 補完時に大文字小文字を区別しない
set virtualedit=all     " カーソルを文字が存在しない部分でも動けるようにする
set hidden              " バッファを閉じる代わりに隠す（Undo履歴を残すため）
set switchbuf=useopen   " 新しく開く代わりにすでに開いてあるバッファを開く
set showmatch           " 対応する括弧などをハイライト表示する
set matchtime=3         " 対応括弧のハイライト表示を3秒にする

" バックスペースでなんでも消せるようにする
set backspace=indent,eol,start

" Swapファイル？Backupファイル？前時代的すぎ
" " なので全て無効化する
set nowritebackup
set nobackup
set noswapfile

"""表示関連
set list                " 不可視文字の可視化
set number              " 行番号の表示
set wrap                " 長いテキストの折り返し
set textwidth=0         " 自動的に改行が入るのを無効化
set colorcolumn=100      " その代わり80文字目にラインを入れる

" 前時代的スクリーンベルを無効化
set t_vb=
set novisualbell

" デフォルト不可視文字は美しくないのでUnicodeで綺麗に
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲

" テンプレート
autocmd BufNewFile *.py 0r $HOME/.vim/template/python.txt
autocmd BufNewFile *.sh 0r $HOME/.vim/template/shell.txt
"""マクロ、キー設定
" 入力モード中に素早くjjと入力した場合はESCとみなす
inoremap jj <Esc>
" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>
" カーソル下の単語を * で検索
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n','g')<CR><CR>
" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" 削除キーでyankしない
nnoremap x "_x
nnoremap d "_d
nnoremap D "_D

" j, k による移動を折り返されたテキストでも自然に振る舞うように変更
nnoremap j gj
nnoremap k gk
" Yで行末までヤンク
nnoremap Y y$

" vを二回で行末まで選択
vnoremap v $h
" TABにて対応ペアにジャンプ
nnoremap <Tab> %
vnoremap <Tab> %
" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" 括弧を補完
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>
" T + ? で各種設定をトグル
nnoremap [toggle] <Nop>
nmap T [toggle]
nnoremap <silent> [toggle]s :setl spell!<CR>:setl spell?<CR>
nnoremap <silent> [toggle]l :setl list!<CR>:setl list?<CR>
nnoremap <silent> [toggle]t :setl expandtab!<CR>:setl expandtab?<CR>
nnoremap <silent> [toggle]w :setl wrap!<CR>:setl wrap?<CR>
" make, grep などのコマンド後に自動的にQuickFixを開く
autocmd MyAutoCmd QuickfixCmdPost make,grep,grepadd,vimgrep copen
" insert modeから抜けた時にnopaste実行
autocmd InsertLeave * set nopaste

" QuickFixおよびHelpでは q でバッファを閉じる
autocmd MyAutoCmd FileType help,qf nnoremap <buffer> q <C-w>c

" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee > /dev/null %
"
" " :e などでファイルを開く際にフォルダが存在しない場合は自動作成
function! s:mkdir(dir, force)
	if !isdirectory(a:dir) && (a:force ||
           \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~?'^y\%[es]$')
               call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
	endif
endfunction
autocmd MyAutoCmd BufWritePre * call s:mkdir(expand('<afile>:p:h'), v:cmdbang)

" インサートモードを抜けると自動的に英数入力にする
if executable('osascript')
let s:keycode_jis_eisuu = 102
let g:force_alphanumeric_input_command = "osascript -e 'tell application \"System Events\" to key code " . s:keycode_jis_eisuu . "' &"

inoremap <silent> <Esc> <Esc>:call system(g:force_alphanumeric_input_command)<CR>

autocmd! FocusGained *
	\ call system(g:force_alphanumeric_input_command)
endif
" vim 起動時のみカレントディレクトリを開いたファイルの親ディレクトリに指定
autocmd MyAutoCmd VimEnter * call s:ChangeCurrentDir('', '')
function! s:ChangeCurrentDir(directory, bang)
if a:directory == ''
	lcd %:p:h
else
	execute 'lcd' . a:directory
endif
if a:bang == ''
	pwd
endif
endfunction

function! IncludePath(path)
	" define delimiter depends on platform
	if has('win16') || has('win32') || has('win64')
		let delimiter = ";"
	else
		let delimiter = ":"
	endif
	let pathlist = split($PATH, delimiter)
	if isdirectory(a:path) && index(pathlist, a:path) ==-1
		let $PATH=a:path.delimiter.$PATH
	endif
endfunction
" ~/.pyenv/shims を $PATH に追加する
" " これを行わないとpythonが正しく検索されない
"IncludePath(expand("~/.pyenv/shims"))
let PATH = expand("~/.pyenv/shims") . ":" . $PATH

"""NeoBundle setup
if has('vim_starting')
	" 初回起動時のみruntimepathにneobundleのパスを指定する
	set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
"NeoBundle初期化
call neobundle#begin(expand('~/.vim/bundle/'))

" NeoBundle自身をNeoBundleで管理させる
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle "nathanaelkane/vim-indent-guides"
let s:hooks = neobundle#get_hooks("vim-indent-guides")
function! s:hooks.on_source(bundle)
	let g:indent_guides_guide_size = 1
endfunction

" gitをvim上から使えるようにする
NeoBundle 'tpope/vim-fugitive'

NeoBundle 'tpope/vim-surround'
NeoBundle 'vim-scripts/Align'
NeoBundle 'vim-scripts/YankRing.vim'
NeoBundle "honza/vim-snippets"
NeoBundle "Shougo/neosnippet.vim"
" Plugin key-mappings.
 imap <C-k>     <Plug>(neosnippet_expand_or_jump)
 smap <C-k>     <Plug>(neosnippet_expand_or_jump)
 xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: "\<TAB>"

NeoBundle "Shougo/neosnippet-snippets"
" For snippet_complete marker.
if has('conceal')
	set conceallevel=2 concealcursor=i
endif

NeoBundleLazy "Shougo/unite.vim", {
      \ "autoload": {
      \   "commands": ["Unite", "UniteWithBufferDir"]
      \ }}
NeoBundleLazy 'h1mesuke/unite-outline', {
      \ "autoload": {
      \   "unite_sources": ["outline"],
      \ }}
nnoremap [unite] <Nop>
nmap U [unite]
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]r :<C-u>Unite register<CR>
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
nnoremap <silent> [unite]c :<C-u>Unite bookmark<CR>
nnoremap <silent> [unite]o :<C-u>Unite outline<CR>
nnoremap <silent> [unite]t :<C-u>Unite tab<CR>
nnoremap <silent> [unite]w :<C-u>Unite window<CR>
nnoremap <silent> [unite]y :<C-u>Unite history/yank<CR>

NeoBundleLazy "Shougo/vimfiler", {
      \ "depends": ["Shougo/unite.vim"],
      \ "autoload": {
      \   "commands": ["VimFilerTab", "VimFiler", "VimFilerExplorer"],
      \   "mappings": ['<Plug>(vimfiler_switch)'],
      \   "explorer": 1,
      \ }}
nnoremap <Leader>e :VimFilerExplorer<CR>
autocmd MyAutoCmd BufEnter * if (winnr('$') == 1 && &filetype ==# 'vimfiler') | q | endif
let s:hooks = neobundle#get_hooks("vimfiler")
function! s:hooks.on_source(bundle)
	let g:vimfiler_as_default_explorer = 1
	let g:vimfiler_enable_auto_cd = 1
	let g:vimfiler_ignore_pattern = "\%(^\..*\|\.pyc$\)"
	autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()
	function! s:vimfiler_settings()
		nmap <buffer> ^^ <Plug>(vimfiler_switch_to_parent_directory)
		nmap <buffer> R <Plug>(vimfiler_redraw_screen)
		nmap <buffer> <C-l> <C-w>l
	endfunction
endfunction

NeoBundleLazy "davidhalter/jedi-vim", {
    \ "autoload": { "filetypes": [ "python", "python3", "djangohtml"] }}

let s:hooks = neobundle#get_hooks("jedi-vim")
function! s:hooks.on_source(bundle)
	 " jediにvimの設定を任せると'completeopt+=preview'するので
	 " 自動設定機能をOFFにし手動で設定を行う
	 let g:jedi#auto_vim_configuration = 0
  " 補完の最初の項目が選択された状態だと使いにくいためオフにする
	 let g:jedi#popup_select_first = 0
	 " quickrunと被るため大文字に変更
	 let g:jedi#rename_command = '<Leader>R'
     " gundoと被るため大文字に変更 (2013-06-24 10:00 追記）
	 let g:jedi#goto_command = '<Leader>G'
endfunction
" jedi-vimの補完時に関数の説明を別ウィンドウで表示しないようにする
autocmd FileType python setlocal completeopt-=preview
NeoBundleLazy 'Shougo/neocomplete.vim', {
    \ "autoload": {"insert": 1}}
" Djangoを正しくVimで読み込めるようにする
NeoBundleLazy "lambdalisue/vim-django-support", {
      \ "autoload": {
      \   "filetypes": ["python", "python3", "djangohtml"]
      \ }}

NeoBundleLazy "lambdalisue/vim-pyenv", {
      \ "autoload": {
      \   "filetypes": ["python", "python3","djangohtml"]
      \ }}
" シンタックスチェック後にquickfixを閉じる
let g:quickrun_config = {
\   "watchdogs_checker/_" : {
\       "hook/close_quickfix/enable_exit" : 1,
\   },
\}
NeoBundle 'hynek/vim-python-pep8-indent'
NeoBundle 'scrooloose/syntastic'
let g:syntastic_python_checkers = ['flake8']
" 1line 80char 制限はさすがにキツイので100文字にする
let g:syntastic_python_flake8_args="--max-line-length=100"

" pep8自動修正

function! Preserve(command)
    " Save the last search.
    let search = @/
    " Save the current cursor position.
    let cursor_position = getpos('.')
    " Save the current window position.
    normal! H
    let window_position = getpos('.')
    call setpos('.', cursor_position)
    " Execute the command.
    execute a:command
    " Restore the last search.
    let @/ = search
    " Restore the previous window position.
    call setpos('.', window_position)
    normal! zt
    " Restore the previous cursor position.
    call setpos('.', cursor_position)
endfunction

function! Autopep8()
    call Preserve(':silent %!autopep8 --max-line-length 99 -')
endfunction

" Shift + F で自動修正
autocmd FileType python nnoremap <S-f> :call Autopep8()<CR>

" エラーメッセージ表示
NeoBundle "dannyob/quickfixstatus"
" 畳み込み
NeoBundleLazy "vim-scripts/python_fold", {
    \ "autoload": { "filetypes": [ "python", "python3", "djangohtml"] }}
" 書き込み後にシンタックスチェックを行う
let g:watchdogs_check_BufWritePost_enable = 1
" 一定時間キー入力がなかった場合にシンタックスチェックを行う
let g:watchdogs_check_CursorHold_enable = 1
" 新しいタブを開いてファイルを編集(vimFiler)
""let g:vimfiler_edit_action = 'tabopen'
" vimFilterをウィンドウ幅30で開く
autocmd VimEnter * VimFiler -split -simple -winwidth=30 -no-quit
"
" 横方向の検索をf,F連打でできるようにする
NeoBundle "rhysd/clever-f.vim"
" ruby用設定
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/vimproc'
let g:rsenseUseOmniFunc = 1
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache#sources#rsense#home_directory = "/usr/local/Cellar/rsense/0.3/libexec"
let g:rsenseHome = "/usr/local/Cellar/rsense/0.3/libexec"
NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }
NeoBundleLazy 'marcus/rsense', {
      \ 'autoload': {
      \   'filetypes': 'ruby',
      \ },
      \ }
NeoBundle 'Shougo/neocomplcache-rsense.vim', {
      \ 'depends': ['Shougo/neocomplcache.vim', 'marcus/rsense'],
      \ }
inoremap <expr> <C-Space> pumvisible() \|\| &omnifunc == '' ?
\ "\<lt>C-n>" :
\ "\<lt>C-x>\<lt>C-o><c-r>=pumvisible() ?" .
\ "\"\\<lt>c-n>\\<lt>c-p>\\<lt>c-n>\" :" .
\ "\" \\<lt>bs>\\<lt>C-n>\"\<CR>"
imap <C-@> <C-Space>

" 終了
call neobundle#end()

" ファイルタイププラグインおよびインデントを有効化
" これはNeoBundleによる処理が終了したあとに呼ばなければならない
filetype plugin indent on

NeoBundleCheck
