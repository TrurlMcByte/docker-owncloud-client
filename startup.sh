#!/bin/bash

#add hostuser so files will be written as this user instead of root

WORK_UID=${WORK_UID:-35}
WORK_GID=${WORK_GID:-35}

groupadd --gid $WORK_GID clouddata
useradd  --uid $WORK_UID --gid $WORK_GID  -d /home/clouddata -m clouddata

if [ "$USER" -a  "$PASSWORD" ] ; then
    SERVER=`echo $URL|sed "s/\// /g"|awk '{ print $2 }'`
    echo "machine $SERVER" > /home/clouddata/.netrc
    echo "	login $USER" >> /home/clouddata/.netrc
    echo "	password $PASSWORD" >> /home/clouddata/.netrc
fi

mkdir -p /home/clouddata/.local/share/data/ownCloud
touch /home/clouddata/.local/share/data/ownCloud/cookies.db

chown $WORK_UID.$WORK_GID /home/clouddata/.netrc
chown -R $WORK_UID.$WORK_GID /home/clouddata/.local
chown -R $WORK_UID.$WORK_GID $LOCALDIR

while true
do
    # Start sync
    su clouddata -c "owncloudcmd --trust --non-interactive --silent -n $LOCALDIR $URL"
    sleep $INTERVAL
done
