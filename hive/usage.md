1.  create table
```
row format delimited
fields terminated by '|'
lines terminated by '\n'
stored as textfile;
```

1.  when use beeline
```
run="/bin/beeline -u \"jdbc:hive2://hnedaint06:10001/default;principal=edc_jk/admin@NBDP.COM\""
${run}<<EOF
${vsql}
!exit
EOF
```

1.  judge is empty or not

```trim``` : remove a blank each for side left and right

```''``` : length(xxx) <> 0

```null``` : is not null

if a='' , then a is not null , but a is empty , so we use length(a)<>0 to limit a is not empty ;
if a=null , then a is not null , and a is empty at the same time .
so to limit a is not empty , use 
```length(trim(a))<>0 and a is not null```

1.  about join

#### (inner) join
#### Left/right/full (outer) join [where …]


#### semi join
it serves for the situation that table a to aquire datas which agree conditions refer to table b
finally , it only will return table a's selected datas
fammiliar to in/exsits's usage

#### map join

```set hive.auto.convert.join = true;``` #default false

on this setting , the script will use map join automatically at little table circumstances


