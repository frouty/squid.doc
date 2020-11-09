#!/bin/bash
# ban youtube.

SQUID_CONF_DIR="/etc/squid"
SQUID_CONF_D="/etc/squid/conf.d"
BAN_YTB_CONF="ban_youtube.conf"
BAN_YTB_CONF_desable="ban_youtube.conf.desable"

echo -n "ban youtube(yes or no)":
read ban

case $ban in 
	yes | y )
		echo "want to ban youtube"
		if [ -f ${SQUID_CONF_D}/${BAN_YTB_CONF} ]; then
		echo "youtube is already banned"
		exit 0
		elif  [ -f ${SQUID_CONF_D}/${BAN_YTB_CONF_desable}  ] ; then
		echo "banning youtube" 
		mv ${SQUID_CONF_D}/${BAN_YTB_CONF_desable} ${SQUID_CONF_D}/${BAN_YTB_CONF}
		echo "Restarting squid service" 
		service squid restart
		exit 0 
		fi
		;;
	no | n )
		echo "Want to unban youtube"
		if [ -f $SQUID_CONF_D/$BAN_YTB_CONF ]; then
		mv $SQUID_CONF_D/$BAN_YTB_CONF $SQUID_CONF_D/$BAN_YTB_CONF_desable
		echo "restarting squid service"
		service squid restart
		else  
		echo "youtube is already unbanned"
		fi
		;;
	*)
		echo "this is not a valid answer"
		;;
esac
exit 0
