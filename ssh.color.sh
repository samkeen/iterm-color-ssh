#!/bin/bash
#
# (1) copy to a bin folder you use.
#   i.e.  ~/bin/ssh.color.sh
#
# (2) set: alias ssh=~/bin/ssh.color.sh
# 
# (3) Add some hostname color profiles (see 'profiles=(' below)
#
# Inspired from http://talkfast.org/2011/01/10/ssh-host-color
# AND
# https://gist.github.com/pol/773849
#

BLACK="0,0,0"
WHITE="255,255,255"
RED="40,0,0"
GREEN="0,40,0"
BLUE="0,0,40"
GREY="64,64,64"
YELLOW="153,153,0"

#######################################
# Add color profiles here
# 
# in format: {ssh hostname}:{color variable}
# No spaces around ':'
#
# i.e.  web_prod:$RED
#######################################
profiles=(
  host_dev:$GREEN
  host_prod:$RED
)
 
set_term_bgcolor(){
  IFS=',' read -a array <<< "$@"
  local R=array[0]
  local G=array[1]
  local B=array[2]
  /usr/bin/osascript <<EOF
tell application "iTerm"
  tell the current terminal
    tell the current session
      set background color to {$(($R*65535/255)), $(($G*65535/255)), $(($B*65535/255))}
    end tell
  end tell
end tell
EOF
}

for profile in ${profiles[*]}
do
    IFS=':' read -a conf <<< "${profile}"
    host_name=${conf[0]}
    rgb_color=${conf[1]}
    if [[ "$@" =~ "${host_name}" ]]; then
      set_term_bgcolor "${rgb_color}"
    fi
done

ssh $@
 
#######################################
# Set the background color you want to
# return to
#######################################
set_term_bgcolor $BLACK
