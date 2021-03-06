#!/bin/bash

if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root"
  exit 1
else
  var_scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  var_cronFile="/etc/cron.d/motioneye-telegram"

  echo "About to install /etc/cron.d/motioneye-telegram with content:"
  echo ""
  echo "##################################################################"
  echo "* * * * * root $var_scriptDir/bin/presencecheck.sh >/dev/null 2>&1"
  echo "##################################################################"
  echo ""

  var_defaultNewCron="y"
  read -p "Create new cronjob? [Y/n]: " var_NewCron
  : ${var_NewCron:=$var_defaultNewCron}

  case $var_NewCron in
  ## [y] create new config file or [n] simply quit.
    [yY] | [yY][eE][sS] )
      echo "Ok, I will create new cronjob."
      touch $var_cronFile
      echo "* * * * * root $var_scriptDir/bin/presencecheck.sh >/dev/null 2>&1" > $var_cronFile
      test $var_cronFile && echo "Successful, end script."; exit 0 || echo "Hmmm.. Something went wrong, no file created..."; exit 1
      ;;

    [nN] | [nN][oO] )
      echo "You selected to not create new cronjob."
      echo "That is Ok, but you have to do this on your own. See ya!"
      exit 0
      ;;

    *)
      echo "Wrong answer given. Abort install."
      exit 1
      ;;
  esac
fi

exit 1
