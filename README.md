# mysql_backuper
This bash script makes mysql dump without service tables(information_schema, erformance_schema,mysql), writes result into log file and sends report to an administrator.

### Installing
```
git clone https://github.com/ozloozlo/mysql_backuper.git && cp mysql_backuper/mysql_backuper.sh /usr/sbin/ && sudo chmod +x /usr/sbin/mysql_backuper.sh && sudo echo "0 0 * * sun /usr/sbin/mysql_backuper.sh" >> /etc/crontab
```
