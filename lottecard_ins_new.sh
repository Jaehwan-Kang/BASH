#!/bin/sh
# 
#  롯데카드 복호화 데이터 입력 PHP 파일 대체  (/root/monitor/lottecard_ins.php)
#  해당 PHP 파일은 당일날짜 (today) 로 검색하여 해당 일자의 파일로 복호화 -> DB 입력
#  간혹 롯데 측에서 14,15,16일에 암호화파일을 전해주지 않고 17일에 14,15,16,17 일자의 파일을 전달 할 경우
#  당일 날짜인 17일자만 자동 입력되고 나머지 14,15,16일자의 파일은 누락되는 건이 발생됨
#  
#													
#  그리하여 12시간기준(cron 설정) 으로 해당 경로의 파일리스트를 작성  ->  lotte_oper_after.txt	<<<<<<<<^	
#  파일 비교 diff 이용, 새로 생긴 파일 확인,    diff lotte_oper_before.txt lotte_oper_after.txt 	^
#  for 루프 이용하여 복호화 진행 및 디비 입력								^
#  기존 lotter_oper_before 삭제,  lotter_oper_after.txt 를 lotter_oper_before.txt 이름 변경     >>>>>>>>^


#########################################################################################################
# 디렉토리 설정 											#
# 													#
# 디렉토리경로 변경이 없고, 작업자가 해당 디렉토리내에서 직접 파일 수정 같은 작업이 없다는 전제조건 필수#
#													#
# lotte_oper DIR											#
L_DIR="/home/lotte_oper/"										#
#													#
# lotte_oper_decoder File										#
D_file="/home/lotte_oper_decoder/Lotter_CaRd.police"							#
#													#
# decoder renewal File											#
R_file="/home/lotte_oper_decoder/Lotter_CaRd.police.renewal"						#
#													#
# diff FILE												#
B_file="/home/lotte_oper_decoder/lotte_oper_before.txt"							#
A_file="/home/lotte_oper_decoder/lotte_oper_after.txt"							#
#													#
#########################################################################################################


# 1. make file list  
ls $L_DIR > $A_file;

# 2. diff file
TMP=`diff $B_file $A_file | grep ">" | awk '{print $2}'`

# 3. diff file == insert DB

if [ "$TMP" != "" ]
	then

	for file in `echo $TMP`
		do
		/home/seed/lcph_client -d -o $D_file $L_DIR$TMP;
		cat $D_file | awk '{print $2" "$3" "$4}' | sed '/^ *$/d' > $R_file;
		
			for chk in `awk '{print $1":"$2":"$3}' $R_file`
				do
				
				# Read Value search
				name=`echo $chk|awk -F: '{print $1}'`
				phone=`echo $chk | awk -F: '{print $2}'`
				r_phone="`echo ${phone:0:4}`-`echo ${phone:4:4}`-`echo ${phone:8:4}`"
				email=`echo $chk | awk -F: '{print $3}'`
				date=`date +%Y"-"%m"-"%d" "%T`
				
				# Insert DataBase
				mysql -h 192.168.0.171 -u dreammiz -pcybermiz -e "use _lottec; insert into dream_lottecd (name, handphone, email, insdate) values ('$name', '$r_phone', '$email', '$date');"
				done
		done
fi
## 4. after -> before  rename
rm -rf $B_file;
mv $A_file $B_file;

## 5. DATA file remove
rm -rf $D_file;
rm -rf $R_file;
