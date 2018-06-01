#!/bin/sh
#####################################################
#描 述：文件入hive库
#调用样式：sh file_upload_hive_mysql.sh inf_net_mre_beier_day 2017061200 -1
####################################################
##授权
kinit -kt /home/edc_jk/edc_jk.keytab edc_jk/admin
###参数校验
if [ $# -lt 3 ];then
    echo " 参数校验失败！脚本参数:表名 账期 本地网"
    echo "retMes <参数校验失败！脚本参数:表名 账期 本地网> "
    echo "retCode -1"
    exit 1
fi
####接收参数
table_code=$1
acct_period=$2
lan_id=$3
if [ ${#acct_period} = 6 ]; then
  month_id=${acct_period}
  day_id=${acct_period}01
  hour_id=0
elif [ ${#acct_period} = 8 ]; then
  month_id=${acct_period:0:6}
  day_id=${acct_period}
  hour_id=0
elif [ ${#acct_period} = 10 ]; then
  month_id=${acct_period:0:6}
  day_id=${acct_period:0:8}
  hour_id=${acct_period}
elif [ ${#acct_period} = 12 ]; then
  month_id=${acct_period:0:6}
  day_id=${acct_period:0:8}
  hour_id=${acct_period:0:10}
  minute_id=${acct_period}
else
  echo "retMes <账期入参错误> "
  echo "retCode -1"
  exit 1
fi
log_file=/inf_file/script/sqludr2/ftpload/log/${table_code}_${acct_period}_${lan_id}.log
check_file=/inf_file/script/sqludr2/ftpload/log/${table_code}_${acct_period}_${lan_id}_check.txt
echo "${table_code} ${acct_period} ${lan_id}">${log_file}
###配置表查询用户
edc_query_user='eteuser'
edc_query_pwd='Qwer123@#$'
edc_query_host='134.176.72.82'
edc_query_port='3306'
edc_query_db='etedb'
edc_query_tab='file_upload_hive'
#####################################
##运行方式
run="mysql -u${edc_query_user} -p${edc_query_pwd} -h${edc_query_host} -P${edc_query_port} ${edc_query_db}"
########取配置信息########
echo "账期：${#acct_period}">>${log_file}
echo "select database_name from ${edc_query_db}.${edc_query_tab}
where upper(table_code)=upper('${table_code}') and upper(state)='00A';" >>${log_file}
##取配置表中的database_name
database_name=`${run} <<EOF 2>/dev/null | tail -n +2
select trim(database_name) from ${edc_query_db}.${edc_query_tab}
where upper(table_code)=upper('${table_code}') and upper(state)='00A';
EOF`
echo "database is :${database_name}">>${log_file}
echo "database is :${database_name}"
##取配置表中的table_name
table_name=`${run} <<EOF 2>/dev/null | tail -n +2
select trim(table_name) from ${edc_query_db}.${edc_query_tab}
where upper(table_code)=upper('${table_code}') and upper(state)='00A';
EOF`
echo "table_name is :${table_name}">>${log_file}
echo "table_name is :${table_name}"
##取得将文件放在接口机上面的路径file_path
file_path=`${run} <<EOF 2>/dev/null | tail -n +2
select replace(replace(replace(replace(replace(trim(file_path),'@LAN_ID@','${lan_id}'),'@DAY_ID@','${day_id}'),'@MONTH_ID@','${month_id}'),'@HOUR_ID@','${hour_id}'),'@MINUTE_ID@','${minute_id}')
from ${edc_query_db}.${edc_query_tab}
where upper(table_code)=upper('${table_code}') and upper(state)='00A';
EOF`
echo "file path is :${file_path}">>${log_file}
echo "file path is :${file_path}"
##取得将文件放在接口机上面的路径file_name
file_name=`${run} <<EOF 2>/dev/null | tail -n +2
select replace(replace(replace(replace(replace(trim(file_name),'@LAN_ID@','${lan_id}'),'@DAY_ID@','${day_id}'),'@MONTH_ID@','${month_id}'),'@HOUR_ID@','${hour_id}'),'@MINUTE_ID@','${minute_id}')
from ${edc_query_db}.${edc_query_tab}
where upper(table_code)=upper('${table_code}') and upper(state)='00A';
EOF`
echo "file name is :${file_name}">>${log_file}
echo "file name is :${file_name}"
##取配置表中的hive_partition
hive_partition=`${run} <<EOF 2>/dev/null | tail -n +2
select replace(replace(replace(replace(replace(trim(hive_partition),'@LAN_ID@','${lan_id}'),'@DAY_ID@','${day_id}'),'@MONTH_ID@','${month_id}'),'@HOUR_ID@','${hour_id}'),'@MINUTE_ID@','${minute_id}')
from ${edc_query_db}.${edc_query_tab}
where upper(table_code)=upper('${table_code}') and upper(state)='00A';
EOF`
echo "hive partition is :${hive_partition}">>${log_file}
echo "hive partition is :${hive_partition}"
##取配置表中的hdfs_path
hdfs_path=`${run} <<EOF 2>/dev/null | tail -n +2
select replace(replace(replace(replace(replace(trim(hdfs_path),'@LAN_ID@','${lan_id}'),'@DAY_ID@','${day_id}'),'@MONTH_ID@','${month_id}'),'@HOUR_ID@','${hour_id}'),'@MINUTE_ID@','${minute_id}')
from ${edc_query_db}.${edc_query_tab}
where upper(table_code)=upper('${table_code}') and upper(state)='00A';
EOF`
echo "hdfs path is :${hdfs_path}">>${log_file}
echo "hdfs path is :${hdfs_path}"
##取配置表中的上传方式upload_type
upload_type=`${run} <<EOF 2>/dev/null | tail -n +2
select trim(upload_type) from ${edc_query_db}.${edc_query_tab}
where upper(table_code)=upper('${table_code}') and upper(state)='00A';
EOF`
echo "upload type is :${upload_type}">>${log_file}
echo "upload type is :${upload_type}"
##取配置表中的is_rerun
is_rerun=`${run} <<EOF 2>/dev/null | tail -n +2
select trim(is_rerun) from ${edc_query_db}.${edc_query_tab}
where upper(table_code)=upper('${table_code}') and upper(state)='00A';
EOF`
echo "is_rerun is :${is_rerun}">>${log_file}
echo "is_rerun is :${is_rerun}"
#新增解压、编码转换
##取配置表中的 is_zip
is_zip=`${run} <<EOF 2>/dev/null | tail -n +2
select trim(is_zip) from ${edc_query_db}.${edc_query_tab}
where upper(table_code)=upper('${table_code}') and upper(state)='00A';
EOF`
echo "is_zip is :${is_zip}">>${log_file}
echo "is_zip is :${is_zip}"
##取配置表中的 is_iconv
is_iconv=`${run} <<EOF 2>/dev/null | tail -n +2
select trim(is_iconv) from ${edc_query_db}.${edc_query_tab}
where upper(table_code)=upper('${table_code}') and upper(state)='00A';
EOF`
echo "is_iconv is :${is_iconv}">>${log_file}
echo "is_iconv is :${is_iconv}"
##取配置表中的 is_sed
is_sed=`${run} <<EOF 2>/dev/null | tail -n +2
select trim(is_sed) from ${edc_query_db}.${edc_query_tab}
where upper(table_code)=upper('${table_code}') and upper(state)='00A';
EOF`
echo "is sed is :${is_sed}">>${log_file}
echo "is sed is :${is_sed}"
##取配置表中的 FTP_IP
ftp_ip=`${run} <<EOF 2>/dev/null | tail -n +2
select trim(ftp_ip) from ${edc_query_db}.${edc_query_tab}
where upper(table_code)=upper('${table_code}') and upper(state)='00A';
EOF`
echo "ftp_ip is :${ftp_ip}">>${log_file}
echo "ftp_ip is :${ftp_ip}"
##取配置表中的 FTP端口
ftp_port=`${run} <<EOF 2>/dev/null | tail -n +2
select trim(ftp_port) from ${edc_query_db}.${edc_query_tab}
where upper(table_code)=upper('${table_code}') and upper(state)='00A';
EOF`
echo "ftp_port is :${ftp_port}">>${log_file}
echo "ftp_port is :${ftp_port}"
##取配置表中的 FTP用户
ftp_user_name=`${run} <<EOF 2>/dev/null | tail -n +2
select trim(ftp_user_name) from ${edc_query_db}.${edc_query_tab}
where upper(table_code)=upper('${table_code}') and upper(state)='00A';
EOF`
echo "ftp_user_name is :${ftp_user_name}">>${log_file}
echo "ftp_user_name is :${ftp_user_name}"
##取配置表中的 FTP密码
ftp_password=`${run} <<EOF 2>/dev/null | tail -n +2
select trim(ftp_password) from ${edc_query_db}.${edc_query_tab}
where upper(table_code)=upper('${table_code}') and upper(state)='00A';
EOF`
echo "ftp_password is :${ftp_password}">>${log_file}
##取配置表中的 FTP路径
ftp_file_path=`${run} <<EOF 2>/dev/null | tail -n +2
select replace(replace(replace(replace(replace(trim(ftp_file_path),'@LAN_ID@','${lan_id}'),'@DAY_ID@','${day_id}'),'@MONTH_ID@','${month_id}'),'@HOUR_ID@','${hour_id}'),'@MINUTE_ID@','${minute_id}')
from ${edc_query_db}.${edc_query_tab}
where upper(table_code)=upper('${table_code}') and upper(state)='00A';
EOF`
echo "ftp_file_path is :${ftp_file_path}">>${log_file}
echo "ftp_file_path is :${ftp_file_path}"
##取配置表中的任务名task_name
task_name=`${run} <<EOF 2>/dev/null | tail -n +2
select trim(task_name) from ${edc_query_db}.${edc_query_tab}
where upper(table_code)=upper('${table_code}') and upper(state)='00A';
EOF`
echo "task_name is :${task_name}">>${log_file}
echo "task_name is :${task_name}"
if [ ${#ftp_ip} -gt 1 ];then
echo "FTP下载文件:" >> ${log_file}
echo "FTP下载文件:"
ftp -n<<EOF | tail -n +2 > ${check_file}
open ${ftp_ip} ${ftp_port}
user ${ftp_user_name} ${ftp_password}
cd ${ftp_file_path}
binary
prompt off
ls ${file_name}
bye
EOF
server_file=`cat ${check_file} | wc -l`
if [ ${server_file} -eq 0 ]; then
   echo "retMes <FTP服务器文件${file_name}不存在>" >> ${log_file}
   echo "retMes <FTP服务器文件${file_name}不存在>"
   echo "retCode:1"
   exit 1
fi
ftp -n <<EOF
open ${ftp_ip} ${ftp_port}
user ${ftp_user_name} ${ftp_password}
lcd ${file_path}
cd ${ftp_file_path}
binary
prompt off
mget ${file_name}
bye
EOF
fi
if [ `ls -l ${file_path}/${file_name}|wc -l|awk '{print $1}'` -ge 1 ];then
  echo "${file_path}/${file_name}文件存在">>${log_file}
  if [ `ls -l ${file_path}/${file_name} | awk '{print $5}' | gawk '{ sum1 += $1 }; END { print sum1 }' ` = 0 -a ${table_name} != "intf_pr_sms_pltfm" ];then
     echo "${file_path}/${file_name}文件大小为0,上传失败！" >>${log_file}
     echo "retMes <${file_path}/${file_name}文件大小为0,上传失败！> "
     echo "retCode -1"
     exit 1
   fi
   #新建分区
   if [ ${#hive_partition} -eq 0 ];then
     echo "不需要新建分区" >>${log_file}
   else
   #新建分区
     ls_sql="use ${database_name};alter table ${table_name} add if not exists partition (${hive_partition});" 
     echo "add partition sql is :${ls_sql}">>${log_file}
     hive -v -e "${ls_sql}"
   fi
   #判断HDFS路径存在
   if [ `hadoop fs -ls ${hdfs_path} 2>/dev/null|wc -l` -lt 0 ];then
     echo "HDFS路径不存在：${hdfs_path},失败！" >>${log_file}
     echo "retMes <HDFS路径不存在：${hdfs_path},失败！> "
     echo "retCode -1"
     exit 1
   fi
   echo "${hdfs_path}"
   #增加解压、转编码
   if [ ${#is_zip} -gt 1 ];then
     if [ ${is_zip} = 'unzip' ] ; then
       for file_zip_name in `ls ${file_path}/${file_name}`
        do
          file_zip_name=${file_zip_name##*/}
          echo "解压命令:${is_zip} -o -d ${file_path}/${file_zip_name}" >>${log_file}
          echo "解压命令:${is_zip} ${file_path}/${file_zip_name}"
          `${is_zip} -o -d ${file_path} ${file_path}/${file_zip_name} 2>/dev/null`
        done
      file_name=${file_name%.*}.txt
      echo "${file_name}---------------------"
     else
      echo "解压命令：${is_zip} ${file_path}/${file_name}" >>${log_file}
      echo "解压命令：${is_zip} ${file_path}/${file_name}"
      `${is_zip} ${file_path}/${file_name} 2>/dev/null`
      file_name=${file_name%.*}
      echo "${file_name}---------------------"
     fi
   fi
   if [ ${#is_iconv} -gt 1 ];then
     for file_list_name in `ls ${file_path}/${file_name}`
      do
         file_list_name=${file_list_name##*/}
         echo "转编码命令：iconv -f ${is_iconv} -t UTF-8 ${file_path}/${file_list_name} >iconv_${file_list_name}" >>${log_file}
         `iconv -f ${is_iconv} -t UTF-8 ${file_path}/${file_list_name} >${file_path}/iconv_${file_list_name}`   
         #file_name=iconv_${file_name}
         echo "${file_name}---------------------"
      done
      file_name=iconv_${file_name}
   fi
   if [ ${#is_sed} -gt 1 ];then
      echo "sed命令：sed -i ${is_sed} ${file_path}/${file_name}" >>${log_file}
      sed_com="sed -i ${is_sed} ${file_path}/${file_name}"
      echo ${sed_com}
      `sed -i "${is_sed}" ${file_path}/${file_name}`
      #file_name=sed_${file_name}
      echo "${file_name}---------------------"
   fi
   if [ ${upload_type} = 0 ];then
     echo "hadoop fs -put ${file_path}/${file_name} ${hdfs_path}/">>${log_file}
     hadoop fs -put ${file_path}/${file_name} ${hdfs_path}/
   elif [ ${upload_type} = 1 ];then
     echo "hadoop fs -put -f ${file_path}/${file_name} ${hdfs_path}/">>${log_file}
     hadoop fs -put -f ${file_path}/${file_name} ${hdfs_path}/
   elif [ ${upload_type} = 2 ];then
     echo "hadoop fs -put ${file_path}/${file_name} ${hdfs_path}/">>${log_file}
     hadoop fs -rm ${hdfs_path}/*
     hadoop fs -put ${file_path}/${file_name} ${hdfs_path}/
   else
     echo "retMes <上传方式错误,失败！> "
     echo "retCode -1"
     exit 1
   fi
   #稽核
   if [ `hadoop fs -ls ${hdfs_path}/${file_name}|awk '{print $5}'|gawk '{ sum += $1 }; END { print sum }'` = `ls -l ${file_path}/${file_name}|awk '{print $5}'|gawk '{ sum1 += $1 }; END { print sum1 }'` ];then
     #删除转编码临时文件
     if [ ${#is_iconv} -gt 1 ];then
        rm ${file_path}/${file_name}
     fi
     #echo "retMes <文件上传成功！> "
     #echo "retCode 0"
     echo "success">>${log_file}
#成功写消息
ls_count=`${run} <<EOF 2>/dev/null | tail -n +2
call edc_data_msg(${acct_period},'${table_name}','${file_name}','${task_name}','${lan_id}',@cnt);
select @cnt;
EOF`
echo ${ls_count}
if [ ${ls_count} -eq 1 ]; then
  echo "retMes <SUCCESS!> "
  echo "retCode 0"
  exit 1
else
  echo "retCode <hive_${table_name}表${acct_period}账期写消息失败！>"
  echo "retMes 1"
  echo "retCode 1"
  exit 1
fi
   else
     echo "retMes <文件稽核不通过，上传失败！> "
     echo "retCode -1"
     echo "文件稽核不通过，上传失败 ">>${log_file}
     exit 1
   fi
else
  if [ ${is_rerun} -eq 1 ]
  then
    echo "retMes <文件没有生成，请等待> "
    echo "retCode 1"
    exit 1
  else
    echo "retMes <文件不存在，失败！> "
    echo "retCode -1"
    exit 1
  fi
fi
