# squid.doc
Version de squid : **squid3 -v**

Connaitre son adresse IP: http://www.ipaddresslocation.org/

# comment lire les lignes de fichier de conf qui ne sont pas des commentaires
`cat /etc/squid/squid.conf | egrep -v "^\s*(#|$)"`

# Enlever tous les commentaires d'un fichier de conf:
**grep -v '^#' /etc/squid3/squid.conf |uniq**. Le probleme c'est que cela converse les lignes vides cela donne un fichier avec pleins de ligles blan

# Creation du volume logique pour le cache.
```
lvcreate -n squid-cache --size 100G big_volume_group
mkreiserfs /dev/big_volume_group/squid-cache
mkdir /squid-cache
mount  /dev/big_volume_group/squid-cache
chown proxy:proxy /squid-cache
squid3 -z
```
# Comment vérifier que squid fontionne:
```
netstat -tulpn | grep :3128
tail -f /var/log/squid/access.log
tail -f /var/log/squid/cache.log
```
`systemctl status squid`

# Comment relancer squid 
`systemctl reload squid`  
`systemctl restart squid` est assez long à se terminer.

# reste à faire 
l'identification par user dans squid comme cela je pourrais l'utiliser dans squidguard.

# Comment ajouter une blacklist
Je ne fais pas cela dans les fichiers de squidguard mais dans squid. 

- 1 Define the ACL
	- `acl "aclname" "acltype" "/path/to/file/blocked_site.txt"`
- 2 Activation de l'ACL
	- `http_access deny "aclname"`ou 
	- `http_access allow "aclname"`
	
## Comment ajouter une url à cette blacklist
```python
su 
touch "url" >> /etc/squid/my_blocked_domains.txt
systemctl reload squid
```

## Comment bloquer youtube
```
su 
mv /etc/squid/conf.d/vids.conf /etc/squid/conf.d/vids.conf.desable
systemctl reload squid
```
# Comment créer la page qui s'affiche quand un site est bloqué=la page de redirection.
## les pages d'erreur sont sous:
/usr/share/squid/errors 
## On définit les pages d'erreur qui seront affichées dans squid.conf:
directive ; `error_directory /usr/share/squid/errors/French`

# squidguard	
## Pour avoir des informations complémentaires sur squidguard
**squidGuard -d -b -P -C all**
Cette commande prend pas mal de temps si l'on met en place un squidGuad.conf.
Il est important de la lancer apres avoir mis en place le squidGuard.conf car seuls les destinations définies dans ce fichiers seront compilés. Et c'est cela qui prend du temps. Et à chaque fois que l'on lance cette commande cela recommence.

## Pour tester si squidGuard fonctionne - Dry Run
**echo "http://www.popcat.com 192.168.1.121/ - - GET" | squidGuard -c /etc/squidguard/squidGuard.conf -d**
avec un nom de site dans la /var/lib/squidguard/db/
Le premier - est un user si on l'a mis en place dans le squidGuard.conf.

## Génération de la base de données
squidGuard -C all
