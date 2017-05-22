#!/bin/sh
# installs config and script to hourly, daily, weekly and monthly cron directories
cd `dirname $0`
if [ -f /etc/zfsnap-periodic.conf ]; then
  echo "WARNING! There is already installed version of config /etc/zfsnap-periodic.conf"
  echo "if you want to install default configuration you should first remove current"
else
  cp -f ./zfsnap-periodic.conf /etc/zfsnap-periodic.conf
fi

for dir in hourly daily weekly monthly; do
  cp -f zfsnap-periodic.sh /etc/cron.$dir/zfsnap-periodic
  chmod +x /etc/cron.$dir/zfsnap-periodic
done
