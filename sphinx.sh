#!/bin/bash

#cp /sphinx.conf.d/sphinx.conf /root/config/sphinx.conf

if [ "${DBUSER}" != "" ]; then
	sed -i -e 's|root|'$DBUSER'|' /root/config/sphinx.conf
	sed -i -e 's|root|'$DBUSER'|' /root/config/youseed-spider-saver.yml
fi

if [ "${DBPASS}" != "" ]; then
	sed -i -e 's|123456|'$DBPASS'|' /root/config/sphinx.conf
	sed -i -e 's|123456|'$DBPASS'|' /root/config/youseed-spider-saver.yml
fi

if [ "${DBHOST}" != "" ]; then
	sed -i -e 's|127.0.0.1|'$DBHOST'|' /root/config/sphinx.conf
	sed -i -e 's|localhost|'$DBHOST'|' /root/config/youseed-spider-saver.yml
fi

if [ "${DBPORT}" != "" ]; then
	sed -i -e 's|3306|'$DBPORT'|' /root/config/sphinx.conf
	sed -i -e 's|3306|'$DBPORT'|' /root/config/youseed-spider-saver.yml
fi

if [ "${MQUSER}" != "" ]; then
	sed -i -e 's|mq_user|'$MQUSER'|' /root/config/youseed-spider-saver.yml
fi

if [ "${MQPASS}" != "" ]; then
	sed -i -e 's|mq_pass|'$MQPASS'|' /root/config/youseed-spider-saver.yml
fi

if [ "${MQPORT}" != "" ]; then
	sed -i -e 's|5672|'$MQPORT'|' /root/config/youseed-spider-saver.yml
fi

echo
echo 'starting indexer.'
echo
/usr/local/sphinx-jieba/bin/indexer -c /root/config/sphinx.conf film --rotate
/usr/local/sphinx-jieba/bin/searchd --config /root/config/sphinx.conf
		



rabbitmq-server &

sleep 10


rabbitmq-plugins enable rabbitmq_management
rabbitmqctl add_user  $MQUSER $MQPASS
rabbitmqctl set_user_tags $MQUSER administrator
rabbitmqctl set_permissions -p / $MQUSER '.*' '.*' '.*'


nohup java -jar -Xms50m -Xmx128m /root/config/youseed-spider-saver-public-1.0.0.jar --config=/root/config/youseed-spider-saver.yml zsky > /root/config/spider-saver-mongo.log 2>&1 &
		
while true;do
 echo 'starting indexer.';
 /usr/local/sphinx-jieba/bin/indexer -c /root/config/sphinx.conf film --rotate
 sleep 36000;
done
