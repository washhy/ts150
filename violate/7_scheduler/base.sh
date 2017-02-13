source /home/ap/dip_ts150/ts150_script/base.sh
sqlfile=/home/ap/dip_ts150/ts150_script/monitor/sql/${curTime}_$$.sql

hive_partition_exists()
{
   table=$1
   partition_date=$2
   database=${3:-ts150}


   echo " use $database;" > $sqlfile
   echo " show partitions $table;" >> $sqlfile

   result=`beeline -f $sqlfile | grep "$partition_date"  | wc -l `
   rm -f $sqlfile

   if [ $result -eq 0 ]; then
      return 1
   fi

   return 0
}

hdfs_file_exists()
{
   table=$1
   partition_path=$2
   database=${3:-ts150}

   outlines=`hadoop fs -ls -R /user/hive/warehouse/${database}.db/$table/${partition_path}/`
   echo $outlines

   is_process=`echo $outlines | grep hive-staging | wc -l`
   result=`echo $outlines | grep 0000 | wc -l `
 

   if [ $result -ge 1 -a $is_process -eq 0 ]; then
      return 0
   fi

   return 1
}

hive_partition_over()
{
   table=$1
   partition_date=$2
   database=${3:-ts150}
   partition_field=${4:-p9_data_date}

   hive_partition_exists $table $partition_date $database
   has_partition=$?

   hdfs_file_exists $table "${partition_field}=${partition_date}" $database
   has_file=$?

   #echo "============"
   #echo $has_partition
   #echo $has_file

   if [ $has_partition -eq 0 -a $has_file -eq 0 ]; then
      return 0
   fi

   return 1
}

gp_pqsl()
{
   schema=${1:-app_siam}

   export HOME=/home/ap/dip
   source $HOME/.bash_profile

   
   if [ $schema == "app_siam" ]; then
      export PGPASSWORD=aca_siam_etl
      psql="psql -h 11.58.112.141 -d saldb -U aca_siam_etl"
   else
      export PGPASSWORD=password
      psql="psql -h 11.36.156.168 -d sordb -U aca_xk_user"
   fi
}

gp_partition_exists()
{
   table=${1:-p2log_cst_query}
   check_date=${2:-20010101}
   schema=${3:-app_siam}

   partition_table=${table}_1_prt_day${check_date}

   gp_pqsl $schema

   echo " set search_path to $schema;" > $sqlfile
   echo " \dt $partition_table;" >> $sqlfile

   result=`$psql -f $sqlfile | grep "$partition_table"  | wc -l `
   rm -f $sqlfile
   #echo $result

   if [ $result -ne 1 ]; then
      return 1
   fi

   return 0
}

local_file_exists()
{
   path=$1

   if [ ! -f $path ]; then
      return 1
   fi

   return 0
}


local_file_num()
{
   path=$1
   name=$2
   if [ $# -ne 2 ]; then
      return 1
   fi

   if [ ! -d $path ]; then
      return 2
   fi

   #ls -rtl $path/$name

   file_num=`ls -rtl $path/$name | wc -l`

   return 0
}

