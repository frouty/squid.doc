# squid.doc
Version de squid : **squid3 -v**

Connaitre son adresse IP: http://www.ipaddresslocation.org/

# comment lire les lignes de fichier de conf qui ne sont pas des commentaires
`cat /etc/squid/squid.conf | egrep -v "^\s*(#|$)"`

# Enlever tous les commentaires d'un fichier de conf:
**grep -v '^#' /etc/squid3/squid.conf |uniq**. Le probleme c'est que cela converse les lignes vides cela donne un fichier avec pleins de ligles blan

# configuration de squid.

- 1 Commencez par sauvegarder le fichier squid.conf  à titre de référence :
` sudo  cd /etc/squid && cp squid.conf squid.conf.defaults`
- 2 création d'un fichier de conf sans les lignes commentées
` cat /etc/squid/squid.conf.defaults | grep -v ^# |grep -v ^$ > /etc/squid/squid.conf`
- 3 systemctl squid restart
- 4 journalctl -xe pour avoir des infos de deboggage.


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
-̀ `service squid reload`
-̀ `service squid restart`


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
```bash
su
echo "url" >> /etc/squid/my_blocked_domains.txt
systemctl reload squid
```
url = .1001jeux.fr par exemple. Le . au début est important.

## Comment bloquer/debloquer youtube
- 1 Créer un fichier ban_youtube.txt avec .youtube.com
- 2 Créer un fichier dans /etc/squid/conf.d avec :
```
acl ban_youtube dstdomain "/etc/squid/ban_youtube.txt"
http_access deny ban_youtube
```
- 3 service squid restart

### Débloquer
`mv ban_youtube.conf ban_youtube.donf.desable`

- 4 use the ban_youtube.sh script : sudo ./ban_youtube.sh

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
L'ip peut être si on a configuré une filtration par ip dans le fichier de conf

## Génération de la base de données
` squidGuard -C all`
puis `chown -R proxy: /var/lib/squidguard/db`


## Mise a jour de la blacklist
> rsync -arpogvt rsync://ftp.ut-capitole.fr/blacklist .
On recupere la blacklist sous dest.
voir le script dans la squid box /root/update_blaclist.sh
Verifier qu'il marche et le mettre en cron weekly.
