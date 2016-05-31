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


## 날짜 설정
DATE=`date +%y%m%d`

## 백업할 고정 VM 리스트
_StaticVM="/root/scripts/vmlist_static"

## VM 리스트 파일
_VMlist="/root/scripts/vmlist"

## 스냅샷 리스트 파일
_VMsnapshot="/root/scripts/snapshotlist"

## export 된 기록 파일
_VMexport="/root/scripts/export"

## 백업 디렉토리
_BakDIR="/XenVmSnapshot"

## 백업서버 211.61.155.148 NFS 마운트
mount -t nfs 211.61.155.148:/data/XenVmSnapshot $_BakDIR

## 스냅샷 삭제시 입력 값 설정 "yes"
answer (){
        echo "yes"
        }

## 전월 백업본 삭제
rm -rf $_BakDIR/*

## 스냅샷 Export 진행 부분

## 매월 1일 진행되는 스크립트 이나  매주(월요일) 스냅샷 스크립트와 겹칠 경우
if [ "`date +%a`" = "Tue" ]
        then

	# 월요일에 진행된 스냅샷 리스트 이용하여 대상 VM만 Export 백업 진행
        for _Export in `cat $_StaticVM`
                do
                _VMname=`cat $_VMsnapshot | grep "$_Export" | awk -F: '{print $1}'`
                _SnapshotUUID=`cat $_VMsnapshot | grep "$_Export" | awk -F: '{print $2}'`
                xe vm-export vm="$_SnapshotUUID" filename=""$_BakDIR/$DATE"_"$_VMname".xva"
                done

        # 월요일 외에 01일 경우 스냅샷 -> Export -> 스냅샷 삭제    
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

## 전체 진행 완료 후 NFS umont
umount $_BakDIR

## 변수 해제
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