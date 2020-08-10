#!/usr/bin/env bash


## Author: Tommy Miland (@tmiland) - Copyright (c) 2020


######################################################################
####                       Apt Update.sh                          ####
####               Automatic apt update script                    ####
####            Script to update Debian or Ubuntu                 ####
####                   Maintained by @tmiland                     ####
######################################################################

version='1.0.0'

#------------------------------------------------------------------------------#
#
# MIT License
#
# Copyright (c) 2020 Tommy Miland
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
#------------------------------------------------------------------------------#
## Uncomment for debugging purpose
#set -o errexit
#set -o pipefail
#set -o nounset
#set -o xtrace
apt_get=$(apt-get -o Dpkg::Progress-Fancy="1")

check_exit_status() {

  if [ $? -eq 0 ]
  then
    echo
    echo "Success"
    echo
  else
    echo
    echo "[ERROR] Process Failed!"
    echo

    read -p "The last command exited with an error. Exit script? (yes/no) " answer

    if [ "$answer" == "yes" ]
    then
      exit 1
    fi
  fi
}

greeting() {

  echo
  echo "Hello, $USER. Let's update your system."
  echo
}

update() {

  sudo apt-get -o Dpkg::Progress-Fancy="1" update;
  check_exit_status

  sudo apt-get -o Dpkg::Progress-Fancy="1" upgrade -y;
  check_exit_status

  sudo apt-get -o Dpkg::Progress-Fancy="1" dist-upgrade -y;
  check_exit_status
}

housekeeping() {

  sudo apt-get -o Dpkg::Progress-Fancy="1" autoremove -y;
  check_exit_status

  sudo apt-get -o Dpkg::Progress-Fancy="1" autoclean -y;
  check_exit_status

  sudo apt-get -o Dpkg::Progress-Fancy="1" purge -y $(dpkg -l | awk '/^rc/ { print $2 }')
  check_exit_status

  sudo updatedb;
  check_exit_status
}

leave() {

  echo
  echo "--------------------"
  echo "- Update Complete! -"
  echo "--------------------"
  echo
  exit
}

greeting
update
housekeeping
leave
