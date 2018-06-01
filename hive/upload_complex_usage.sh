 1. mysql信息记录表结构：
| file_upload_hive | CREATE TABLE `file_upload_hive` (
  `sys_name` varchar(100) DEFAULT NULL COMMENT '来源系统',
  `database_name` varchar(50) DEFAULT NULL COMMENT '数据库名称(hive)',
   `table_name` varchar(50) DEFAULT NULL COMMENT '上传hive文件表名',
  `table_code` varchar(50) NOT NULL COMMENT '脚本入参抽取配置表数据唯一标示(含表名)',
  `file_path` varchar(200) DEFAULT NULL COMMENT '本地文件路径',
  `file_name` varchar(200) DEFAULT NULL COMMENT '文件名(本地,FTP一致)',
  `hive_partition` varchar(200) DEFAULT NULL COMMENT '上传到hive表时,需要新建分区时需要用到',
  `hdfs_path` varchar(200) DEFAULT NULL COMMENT 'hdfs路径',
  `upload_type` varchar(2) DEFAULT NULL COMMENT '上传方式:0追加上传,1覆盖同名文件,2清空路径下文件后上传文件',
  `is_rerun` varchar(2) DEFAULT NULL COMMENT '是否重新等待:0不重新等待,1重新等待',
  `state` varchar(5) DEFAULT NULL COMMENT '状态:00A有效;00X失效',
  `ftp_ip` varchar(50) DEFAULT NULL COMMENT 'FTPIP地址',
  `ftp_port` varchar(50) DEFAULT NULL COMMENT 'FTP端口',
  `ftp_user_name` varchar(50) DEFAULT NULL COMMENT 'FTP用户名',
  `ftp_password` varchar(50) DEFAULT NULL COMMENT 'FTP密码',
  `ftp_file_path` varchar(200) DEFAULT NULL COMMENT 'FTP路径',
  `is_zip` varchar(20) DEFAULT NULL COMMENT '是否压缩,并提供压缩命令(文件名不需要)',
  `is_iconv` varchar(20) DEFAULT NULL COMMENT '是否转码,填写文件源编码格式(大写,统一改成UTF-8)',
  `is_sed` varchar(50) DEFAULT NULL COMMENT '是否使用sed命令删除字符串对应行,填写sed命令内容',
  `task_name` varchar(200) DEFAULT NULL COMMENT '调度任务名',
  `comment2` varchar(200) DEFAULT NULL COMMENT '备注',
  `comment3` varchar(200) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文件入hive库配置信息表' |
 2. 连接mysql
mysql -ueteuser -pQwer123@#$ -h134.176.72.83 -P3306 etedb
mysql -uroot -pZaq1@wsx -h134.176.72.82 -P3306
 3. 添加配置
insert into file_upload_hive(
sys_name,
database_name,
table_name,
table_code,
file_path,
file_name,
hive_partition,
hdfs_path,
upload_type,
is_rerun,
state,
ftp_ip,
ftp_port,
ftp_user_name,
ftp_password,
ftp_file_path,
is_zip,
is_iconv,
is_sed,
task_name)
values(
'激活系统', ##来源系统
'cs_ete', ##数据库名称(hive)
'intf_echanl_send_order', ##上传hive文件表名
'intf_echanl_send_order', ##脚本入参抽取配置表数据唯一标示(含表名)
'/inf_file/edc_inf/channel', ##本地文件路径
'sms_channel_@HOUR_ID@.dat', ##文件名
'p_day_id=@DAY_ID@,p_hour_id=@HOUR_ID@', ###上传到hive表时,需要新建分区时需要用到
'/user/hive/warehouse/cs_ete.db/intf_echanl_send_order/p_day_id=@DAY_ID@/p_hour_id=@HOUR_ID@', ##hdfs路径
'1', ##上传方式:0追加上传,1覆盖同名文件,2清空路径下文件后上传文件
'0', ##是否重新等待:0不重新等待,1重新等待
'00A', ##状态:00A有效;00X失效
'', ##FTPIP地址
'', ##FTP端口
'', ##FTP用户名
'', ##FTP密码
'', ##FTP路径
'unzip', ##是否压缩,并提供压缩命令(文件名不需要)
'', ##是否转码,填写文件源编码格式(大写,统一改成UTF-8)
'', ##是否使用sed命令删除字符串对应行,填写sed命令内容
'渠道发送订单表' ##调度任务名
);
commit;
4.执行命令
/inf_file/script/sqludr2/ftpload/file_upload_hive_mysql.sh intf_echanl_send_order 2017112711 -1 ;
