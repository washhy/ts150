curDate=`date +%Y%m%d`
logTime=`date "+%Y-%m-%d %H:%M:%S"`
touch /home/ap/dip_ts150/ts150_script/sms/log/${curDate}_sms.log
chmod a+rwx /home/ap/dip_ts150/ts150_script/sms/log/${curDate}_sms.log

content=${1:-"告警测试,TS150"}
mobile_list=${2:-"18606991939 13950142527"}

for mobile in $mobile_list; do
   echo $logTime $mobile $content >> /home/ap/dip_ts150/ts150_script/sms/log/${curDate}_sms.log

   curl http://11.168.35.34:8101/uassService/uassserviceaction.action -d uaap_request_result=json -d _fw_service_id=sendSms -d userName=TS150 -d handSet=$mobile -d opName=SMS -d operator=TS150 -d smsContent="$content" >> /home/ap/dip_ts150/ts150_script/sms/log/${curDate}_sms.log

   echo "" >> /home/ap/dip_ts150/ts150_script/sms/log/${curDate}_sms.log

done

