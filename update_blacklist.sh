! /bin/sh                                                                                                                            

## update blacklist                                                                                                                   


# L'exécution du script est réservée à root                                                                                           
if [ `id -u` != 0 ]; then
  echo
  echo ":: Désolé, vous devez être root pour exécuter ce script."
  echo
  exit
fi

HOST=ftp.ut-capitole.fr
# Path blacklist                                                                                                                      
BLACKPATH=/var/lib/squidguard/blacklist

# Stop squid                                                                                                                          
systemctl stop squid

cd $BLACKPATH
rsync -arpogvt rsync://$HOST/blacklist .

chown -R proxy:proxy dest

#construction de la base de données des sites                                                                                         
echo ":: Construction de la base de données des sites..."
squidGuard -C all

# Rectifier les permissions                                                                                                           
chown -R proxy:proxy /var/lib/squidguard
chown -R proxy:proxy /var/log/squidguard


# Redémarrer Squid                                                                                                                    
systemctl start squid
