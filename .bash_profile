#
# ~/.bash_profile
#

#[[ -f ~/.profile ]] && . ~/.profile
[[ -f ~/.profile ]] && source ~/.profile
[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -e /home/zhifan/.nix-profile/etc/profile.d/nix.sh ]; then . /home/zhifan/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
