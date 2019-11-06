call plug#begin('~/.local/share/nvim/plugged')
	Plug 'https://github.com/alvan/vim-closetag'
"	Plug 'mxw/vim-jsx'
"	Plug 'pangloss/vim-javascript'
"
"Color scheme
    Plug 'dikiaap/minimalist'
"	Plug 'https://github.com/dense-analysis/ale'
  	"Plug 'Valloric/YouCompleteMe', { 'do': './install.py --tern-completer' }
	Plug 'jiangmiao/auto-pairs'
	Plug 'https://github.com/Valloric/MatchTagAlways'
	Plug 'scrooloose/nerdtree'
    Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'},
"Fuzzy search
    Plug '/usr/bin/fzf'
    Plug 'junegunn/fzf.vim'
call plug#end()

"""""""""""""""""""""""
"Plugins configuration"
"""""""""""""""""""""""
"MatchTagAlways
source ~/.config/nvim/config/plugins.conf.d/match_tag_always.vimrc

"vim-closetag
source ~/.config/nvim/config/plugins.conf.d/vim-closetag.vimrc

"NeoClide
source ~/.config/nvim/config/plugins.conf.d/neoclide-cocvim.vimrc

"junegunn/fzf.vim
source ~/.config/nvim/config/plugins.conf.d/fzf.vimrc
