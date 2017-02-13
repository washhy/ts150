source /home/ap/dip_ts150/ts150_script/monitor/base.sh


title="安全监控--p2日志文件处理告警"

p2log_file_finished()
{
    data_path=/home/ap/dip/file/archive/input/ts150/000000000/data/P2

    local_file_exists $data_path/bj1logap01.${check_date}.finished
    finished_file_found=$?

    local_file_num $data_path "*${check_date}*"
    if [ $? -gt 0 -o $file_num -lt 3400 -o $finished_file_found -ne 0 ]; then
       /home/ap/dip_ts150/ts150_script/sms/sendMail.sh "${check_date} p2log file not finished" $title
    
    fi
}

gp_over()
{
    gp_partition_exists p2log_cst_query $check_date
    if [ $? -gt 0 ]; then
       /home/ap/dip_ts150/ts150_script/sms/sendMail.sh "${check_date} p2log gp table not import" $title
    
    fi

}

hive_over()
{
   hive_partition_over p2log_cst_query $check_date
   if [ $? -gt 0 ]; then
       /home/ap/dip_ts150/ts150_script/sms/sendMail.sh "${check_date} p2log hive table not import" $title
    
    fi

}

arg()
{
   local OPTIND
   unset OPTIND

   OPT=no

   while getopts "fhgd:" OPTION
   do
      case $OPTION in
         f)
           OPT=f
           ;;
         h)
           OPT=h
           ;;
         g)
           OPT=g
           ;;
         d)data_date=$OPTARG
           ;;
         \?)
           echo "$0 -f | -h | -g | -d 20160101"
           exit 1
           ;;
      esac
   done

   if [ $OPT == "no" ]; then
      echo "$0 -f | -h | -g | -d 20160101"
      exit 1
   fi

   if [ "${data_date:-NULL}" != "NULL" ]; then
      valid_date $data_date
      if [ $? -ne 0 ]; then
         echo "data_date format error"
         exit 1
      fi
   fi
   check_date=${data_date:-$less_1_date}

   unset OPTIND
}

arg $*
case $OPT in
   f) p2log_file_finished
      ;;
   h) hive_over
      ;;
   g) gp_over
      ;;
esac

