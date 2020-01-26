call plug#begin('~/.local/share/nvim/plugged')
"closetag for html
    Plug 'alvan/vim-closetag'
	Plug 'MaxMEllon/vim-jsx-pretty'
"
"Color scheme
    Plug 'dikiaap/minimalist'
"autopair for parenthesis
	Plug 'jiangmiao/auto-pairs'
	Plug 'https://github.com/Valloric/MatchTagAlways'
	Plug 'scrooloose/nerdtree'
    Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'},
"Fuzzy search
    Plug '/usr/bin/fzf'
    Plug 'junegunn/fzf.vim'
"Session management with tmux
    Plug 'tpope/vim-obsession'
    Plug 'tpope/vim-surround'
"TagBar
    Plug 'liuchengxu/vista.vim'
"Status line
    Plug 'liuchengxu/eleline.vim'
"Show diffs
    Plug 'mhinz/vim-signify'
call plug#end()

"""""""""""""""""""""""
"Plugins configuration"
"""""""""""""""""""""""
"TagBar
"source ~/.config/nvim/config/plugins.conf.d/tagbar.vimrc

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

"firenvim
"source ~/.config/nvim/config/plugins.conf.d/firenvim.vimrc

"vista
source ~/.config/nvim/config/plugins.conf.d/vista.vimrc

"eleline
source ~/.config/nvim/config/plugins.conf.d/eleline.vimrc

"vim-signify
source ~/.config/nvim/config/plugins.conf.d/vim-signify.vimrc
