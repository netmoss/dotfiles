#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias zzz='systemctl suspend'
alias vpn-on='nmcli connection up "wg0"'
alias vpn-off='nmcli connection down "wg0"'
PS1='[\u@\h \W]\$ '
export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:/home/netmoss/.local/share/flatpak/exports/share"
