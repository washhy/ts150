curDate=`date +%Y%m%d`
logTime=`date "+%Y-%m-%d %H:%M:%S"`
touch /home/ap/dip_ts150/ts150_script/sms/log/${curDate}_mail.log
chmod a+rwx /home/ap/dip_ts150/ts150_script/sms/log/${curDate}_mail.log

content=${1:-"告警测试,TS150"}
title=${2:-"安全监控组件告警"}
mailbox_list=${3:-"wuzhaohui@tienon.com chencheng@tienon-xm.com"}

for mailbox in $mailbox_list; do
   echo "$logTime $mailbox $title" $content >> /home/ap/dip_ts150/ts150_script/sms/log/${curDate}_mail.log

   curl -s http://11.168.35.34:8101/uassService/uassserviceaction.action -d uaap_request_result=json -d _fw_service_id=sendMail -d userName=TS150 -d mailbox=$mailbox -d opName=SMS -d operator=TS150 -d mailContent="$content" -d mailTitle="$title" >> /home/ap/dip_ts150/ts150_script/sms/log/${curDate}_mail.log

   echo "" >> /home/ap/dip_ts150/ts150_script/sms/log/${curDate}_mail.log

done


