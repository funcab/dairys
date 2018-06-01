# Sftp usages
```
sftp username@ip
cd/mkdir/ls (-r) xxx
lcd/lmkdir/lls (-r) xxx
put (-r) xxx //upload
get (-r) xxx //download
```

# Exchange
Exchange all a in file xxx with b
```
sed -i 's/a/b/g' xxx
```

# Batch kill
Kill all process of a known script
```
ps -ef | grep ./xixi.sh | awk '{print $2}'| xargs -t -i kill {}
```
Kill all process of a known application_id
```
yarn application --list | grep bcetl | awk '{print $1}' | xargs -t -i yarn application -kill {}
```

# Calculate size
Calculate the sum of file sizes that meet the conditions in a directory
```
du -m --max-depth=1 *16206*0902*dat.gz | awk '{sum += $1}; END{print sum}'
```
