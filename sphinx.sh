#!/bin/bash

cp /sphinx.conf.d/sphinx.conf /root/config/sphinx.conf

if [ "${DBUSER}" != "" ]; then
	sed -i -e 's|root|'$DBUSER'|' /root/config/sphinx.conf
fi
if [ "${DBPASS}" != "" ]; then
	sed -i -e 's|123456|'$DBPASS'|' /root/config/sphinx.conf
fi

if [ "${DBHOST}" != "" ]; then
	sed -i -e 's|127.0.0.1|'$DBHOST'|' /root/config/sphinx.conf
fi
if [ "${DBPORT}" != "" ]; then
	sed -i -e 's|3306|'$DBPORT'|' /root/config/sphinx.conf
fi

echo
echo 'starting indexer.'
echo
/usr/local/sphinx-jieba/bin/indexer -c /root/config/sphinx.conf film --rotate
/usr/local/sphinx-jieba/bin/searchd --config /root/config/sphinx.conf
		
		
while true;do
 echo 'starting indexer.';
 /usr/local/sphinx-jieba/bin/indexer -c /root/config/sphinx.conf film --rotate
 sleep 36000;
done
