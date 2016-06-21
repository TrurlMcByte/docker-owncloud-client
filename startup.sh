#!/bin/sh

#add hostuser so files will be written as this user instead of root

WORK_UID=${WORK_UID:-82}
WORK_GID=${WORK_GID:-82}

INTERVAL=${INTERVAL:-30}
WORK_GROUP=clouddata
LOCALDIR=${LOCALDIR:-/data}

addgroup -S -g $WORK_GID $WORK_GROUP || WORK_GROUP=`awk -F: -v g=8 '$3==g {print $1}' /etc/group`
adduser -u $WORK_UID -D -s /bin/sh -S -G $WORK_GROUP clouddata

if [ "$USER" -a  "$PASSWORD" ] ; then
    SERVER=`echo $URL|sed "s/\// /g"|awk '{ print $2 }'`
    echo "machine $SERVER" > /home/clouddata/.netrc
    echo "	login $USER" >> /home/clouddata/.netrc
    echo "	password $PASSWORD" >> /home/clouddata/.netrc
fi

mkdir -p /etc/owncloud-client
touch /etc/owncloud-client/sync-exclude.lst
mkdir -p /etc/ownCloud
touch /etc/ownCloud/sync-exclude.lst

mkdir -p /home/clouddata/.local/share/data/ownCloud
touch /home/clouddata/.local/share/data/ownCloud/cookies.db

touch $LOCALDIR/exclude.lst
chown $WORK_UID.$WORK_GID /home/clouddata/.netrc
chown -R $WORK_UID.$WORK_GID /home/clouddata/.local
chown -R $WORK_UID.$WORK_GID $LOCALDIR

while true
do
    # Start sync
    su clouddata -c "owncloudcmd --trust --non-interactive --silent -h -n $LOCALDIR $URL &> /home/clouddata/sync.log"
    sleep $INTERVAL
done
