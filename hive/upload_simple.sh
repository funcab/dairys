#!/bin/bash
##授权
kinit -kt /home/edc_jk/edc_jk.keytab edc_jk/admin
##参数校验
if [ $# -ne 1 ]; then
  echo "retCode <运行 需要1个参数 账期 示例：2017061212 >"
  echo "retMes -1"
  echo "retCode -1"
  exit 1
fi
acct_time=$1
##
if [ ${#acct_time} = 10 ]; then
  p_day_id=${acct_time:0:8}
  p_hour_id=${acct_time}
else
  echo "retMes <账期入参错误> "
  echo "retCode -1"
  exit 1
fi
hive -e "use cs_ete;LOAD DATA LOCAL INPATH '/inf_file/edc_inf/ump/ECP_SMP_20171011.dat' OVERWRITE INTO TABLE INTF_PR_SMS_PLTFM partition(p_day_id=${p_day_id},p_hour_id=
${p_hour_id});"
