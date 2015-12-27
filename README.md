# my-vimrc  
pythonの統合開発環境（っぽい）をvimで構築する。  
設定ファイル(.vimrc)

## 使い方 
###  下準備
vim7.3では補完が出ないため、vim7.4にアップデート  

```
$ vim --version
$ brew install vim --with-python3  
$ source ~/.bash_profile  
$ vim --version
``` 

### クローン  

```
$ cd ~/Downloads
$ git clone [このリポジトリ] 
$ cd ~/Downloads/my-vimrc  
```

### 設定ファイルをコピー  

```
$ cp .vimrc $HOME/.vimrc
```

### 読み込むプラグインをコピー  

```
$ cp -r .vim ~
```

### jedi-vim(補完プラグイン)初期化   

```
$ cd ~/.vim/bundle/jedi-vim
$ git submodule update --init
```

### 全てのプラグイン読み込み  
vimを開始すると、.vimrcがロードされて、  
自動的にプラグインがダウンロード、インストールされる  

```
$ vim
```   

### 使い方(vim内)  
#### 補完を出す : Ctrl+Space  
※ Spotlight検索のショートカットとかぶっている場合は  
Spotlight検索のショートカットをオフ  
#### PyEnvのバージョンを読み込む  
vim内で  
:PyenvActivate dataAnalysis3.3.6  
※tab補完が効くので、Py[tab], data[tab]でok  

#### ファイルエクスプローラへ移動  
Ctrl+h,l  

### その他のカスタムコマンドについて  
.vimrcに割りと詳しくコメントを書いているので、参照してください  

### 今後やっていきたい事  
* スニペット対応  
* タグジャンプ  
* マルチタブ対応   
