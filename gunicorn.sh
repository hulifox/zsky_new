#!/bin/bash

# SS_CONFIG=${SS_CONFIG:-""}
# SS_MODULE=${SS_MODULE:-"ss-server"}
# KCP_CONFIG=${KCP_CONFIG:-""}
# KCP_MODULE=${KCP_MODULE:-"kcpserver"}
# KCP_FLAG=${KCP_FLAG:-"false"}
# RNGD_FLAG=${RNGD_FLAG:-"false"}


cd /root/zsky_new
mkdir uploads
if [ "${DBPASS}" != "" ]; then
	sed -i -e 's|123456|'$DBPASS'|' manage.py
#	sed -i -e 's|123456|'$MYSQL_ROOT_PASSWORD'|' simdht_worker.py
fi
if [ "${DBUSER}" != "" ]; then
	sed -i -e 's|root|'$DBUSER'|' manage.py
fi

if [ "${DOMAIN}" != "" ]; then
	sed -i -e 's|116.196.82.73|'$DOMAIN'|' manage.py
fi


if [ "${DBHOST}" != "" ]; then
	sed -i -e 's|db.example.com|'$DBHOST'|' manage.py
fi

if [ "${DBPORT}" != "" ]; then
	sed -i -e 's|3306|'$DBPORT'|' manage.py
fi


redis-server &
#数据库建表
python manage.py init_db
#创建管理员,会提示输入管理员用户名和密码,邮箱
python manage.py create_user -u $ADMIN_NAME -p $ADMIN_PASS -e $ADMIN_EMAIL


#启动后端gunicorn+gevent,开启日志并在后台运行
#nohup gunicorn -k gevent --access-logfile zsky.log --error-logfile zsky_err.log  manage:app -b 0.0.0.0:8000 -w 4 --reload>/dev/zero 2>&1&  
nohup gunicorn --access-logfile zsky.log --error-logfile zsky_err.log  manage:app -b 0.0.0.0:8000 -w 4 --reload>/dev/zero 2>&1&  



#确定是否正确安装
echo '当前进程运行状态:'
pgrep -l gunicorn

while true;do 
	echo hello docker;
	sleep 100;
done
