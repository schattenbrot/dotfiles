set fish_greeting
setenv EDITOR vim
setenv VISUAL vim

if status is-interactive
    # Commands to run in interactive sessions can go here
end

################################################################################
## ALIAS
################################################################################
# navigation
alias ..='cd ..'
alias ...='cd ../..'

# general linux commands
alias ls='exa --long --git --icons'
alias ll='exa --long --git -a --icons'
alias rmdir!='rm -r'
alias df='df -H'
alias cls='clear'

# git
alias g='git'
alias gdot='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'

# shorten
alias v='vim'
alias k='kubectl'

# paru
alias uwu='paru --bottomup'

# golang
function gotest
  if count $argv > /dev/null
      go test -v ./... -coverprofile cover.out | sed ''/PASS/s//(printf "\033[32mPASS\033[0m")/'' | sed ''/FAIL/s//(printf "\033[31mFAIL\033[0m")/''
      go tool cover -html=cover.out
  else
    go test -v ./... | sed ''/PASS/s//(printf "\033[32mPASS\033[0m")/'' | sed ''/FAIL/s//(printf "\033[31mFAIL\033[0m")/''
  end
end

function pyon
	echo "usa usa pyon pyon! uwu nya~ <3"
end

################################################################################
## PATH_VARIABLES
################################################################################

fish_add_path $HOME/go/bin
fish_add_path $HOME/Dev/unix-block-course/bin
export CAPACITOR_ANDROID_STUDIO_PATH=/usr/bin/android-studio
setxkbmap eu
