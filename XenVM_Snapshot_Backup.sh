#!/bin/sh
#
#
# by. Jaehwan Kang  2016.03.11
# 
# Cyebiz XenServer Snapshot (Only Snapshot)
#
##################################################################
#
# v0.1) Default Script :  /root/scripts/XenVM_Snapshot_Backup.sh

## DELETE a Weekended Snapshot
exec < /root/scripts/snapshotlist

## Return comment "yes"
answer (){
        echo "yes"
        }

while read _Log
        do
        _SnapshotOldUUID=`echo $_Log | awk -F: '{print $2}'`
        `answer | xe snapshot-uninstall snapshot-uuid="$_SnapshotOldUUID"`
        done

## Delete Snapshot list
rm -rf /root/scripts/snapshotlist;

## DATE
DATE=`date +%y%m%d`

## VMlist FILE
xe vm-list | grep "name-label" | awk -F: '{print $2}' | grep "(." | cut -c 2- > /root/scripts/vmlist

## read vm lists 
exec < /root/scripts/vmlist

## snapshots and snapshot LOG
while read _VMname
        do
        _SnapshotUUID=`xe vm-snapshot vm="$_VMname" new-name-label="$DATE"_"$_VMname" new-name-description="$DATE"_"$_VMname"`
        echo "$_VMname:$_SnapshotUUID" >> /root/scripts/snapshotlist
        done

## 변수 해제
unset DATE;
unset _Log;
unset _SnapshotUUID;
unset _SnapshotOldUUID;
unset LOG;
unset _VMname;