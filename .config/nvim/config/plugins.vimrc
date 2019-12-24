call plug#begin('~/.local/share/nvim/plugged')
	Plug 'https://github.com/alvan/vim-closetag'
	Plug 'MaxMEllon/vim-jsx-pretty'
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
    Plug 'tpope/vim-obsession'
    Plug 'majutsushi/tagbar'
call plug#end()

"""""""""""""""""""""""
"Plugins configuration"
"""""""""""""""""""""""
source ~/.config/nvim/config/plugins.conf.d/tagbar.vimrc

"MatchTagAlways
source ~/.config/nvim/config/plugins.conf.d/match_tag_always.vimrc

"vim-closetag
source ~/.config/nvim/config/plugins.conf.d/vim-closetag.vimrc

"cocvim
source ~/.config/nvim/config/plugins.conf.d/neoclide-cocvim.vimrc

"junegunn/fzf.vim
source ~/.config/nvim/config/plugins.conf.d/fzf.vimrc

"nerdtree
source ~/.config/nvim/config/plugins.conf.d/nerdtree.vimrc
