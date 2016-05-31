#!/bin/sh
#
#
# by. Jaehwan Kang  2016.03.11
# 
# Cyebiz XenServer Export VM Snapshot
#
##################################################################
#
# v0.1) Default Script :  /root/scripts/XenVM_Snapshot_Backup_Export.sh


## ��¥ ����
DATE=`date +%y%m%d`

## ����� ���� VM ����Ʈ
_StaticVM="/root/scripts/vmlist_static"

## VM ����Ʈ ����
_VMlist="/root/scripts/vmlist"

## ������ ����Ʈ ����
_VMsnapshot="/root/scripts/snapshotlist"

## export �� ��� ����
_VMexport="/root/scripts/export"

## ��� ���丮
_BakDIR="/XenVmSnapshot"

## ������� 211.61.155.148 NFS ����Ʈ
mount -t nfs 211.61.155.148:/data/XenVmSnapshot $_BakDIR

## ������ ������ �Է� �� ���� "yes"
answer (){
        echo "yes"
        }

## ���� ����� ����
rm -rf $_BakDIR/*

## ������ Export ���� �κ�

## �ſ� 1�� ����Ǵ� ��ũ��Ʈ �̳�  ����(������) ������ ��ũ��Ʈ�� ��ĥ ���
if [ "`date +%a`" = "Tue" ]
        then

	# �����Ͽ� ����� ������ ����Ʈ �̿��Ͽ� ��� VM�� Export ��� ����
        for _Export in `cat $_StaticVM`
                do
                _VMname=`cat $_VMsnapshot | grep "$_Export" | awk -F: '{print $1}'`
                _SnapshotUUID=`cat $_VMsnapshot | grep "$_Export" | awk -F: '{print $2}'`
                xe vm-export vm="$_SnapshotUUID" filename=""$_BakDIR/$DATE"_"$_VMname".xva"
                done

        # ������ �ܿ� 01�� ��� ������ -> Export -> ������ ����    
        else
                exec < $_StaticVM 
                while read _VMname
                        do
                        _SnapshotUUID=`xe vm-snapshot vm="$_VMname" new-name-label="$DATE"_"$_VMname" new-name-description="$DATE"_"$_VMname"`;
                        _Estat=`xe vm-export vm="$_SnapshotUUID" filename="$_BakDIR/$DATE"_"$_VMname.xva"`;
                        echo "$DATE:$_VMname:$_Estat" >> $_VMexport;
                        `answer | xe snapshot-uninstall snapshot-uuid="$_SnapshotUUID"`;
                        done

fi

## ��ü ���� �Ϸ� �� NFS umont
umount $_BakDIR

## ���� ����
unset DATE;
unset _StaticVM;
unset _VMlist;
unset _VMsnapshot;
unset _VMexport;
unset _BakDIR;
unset _Export;
unset _VMname;
unset _SnapshotUUID;
unset _Estat;