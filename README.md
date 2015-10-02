#squid.doc
Version de squid
Squid fonctionne
Connaitre son adresse IP
http://www.ipaddresslocation.org/
Enlever tous les commentaires d'un fichier de conf
egrep -v '^(#|[ ]*#)' /etc/squid3/squid.conf. Le probleme c'est que cela converse les lignes vides cela donne un fichier avec pleins de ligles blan

creation du volume logique pour le cache.
lvcreate -n squid-cache --size 100G big_volume_group
mkreiserfs /dev/big_volume_group/squid-cache
mkdir /squid-cache
mount  /dev/big_volume_group/squid-cache
chown proxy:proxy /squid-cache
squid3 -z

Comment vérifier que squid fontionne
netstat -tulpn | grep :3128
tail -f /var/log/squid/access.log
tail -f /var/log/squid/cache.log
