#squid.doc
Version de squid : **squid3 -v**

Connaitre son adresse IP: http://www.ipaddresslocation.org/

#Enlever tous les commentaires d'un fichier de conf:
**grep -v '^#' /etc/squid3/squid.conf |uniq**. Le probleme c'est que cela converse les lignes vides cela donne un fichier avec pleins de ligles blan

#Creation du volume logique pour le cache.
```
lvcreate -n squid-cache --size 100G big_volume_group
mkreiserfs /dev/big_volume_group/squid-cache
mkdir /squid-cache
mount  /dev/big_volume_group/squid-cache
chown proxy:proxy /squid-cache
squid3 -z
```

#Comment vérifier que squid fontionne:
```
netstat -tulpn | grep :3128
tail -f /var/log/squid/access.log
tail -f /var/log/squid/cache.log
```

#pour avoir des informations complémentaires sur squidguard
**squidGuard -d -b -P -C all**
Cette commande prend pas mal de temps si l'on met en place un squidGuad.conf.
Il est important de la lancer apres avoir mis en place le squidGuard.conf car seuls les destinations définies dans ce fichiers seront compilés. Et c'est cela qui prend du temps. Et à chaque fois que l'on lance cette commande cela recommence.

#pour tester si squidGuard fonctionne - Dry Run
**echo "http://www.popcat.com 192.168.1.121/ - - GET" | squidGuard -c /etc/squidguard/squidGuard.conf -d**
avec un nom de site dans la /var/lib/squidguard/db/
Le premier - est un user si on l'a mis en place dans le squidGuard.conf.

#reste à faire 
l'identification par user dans squid comme cela je pourrais l'utiliser dans squidguard.

#Ou est ce que l'on définie la page de redirection. 