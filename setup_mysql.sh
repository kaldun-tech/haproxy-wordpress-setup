#/bin/bash
# Setup MySQL
# Requires a database name $NAME variable to be defined or as first argument
if [ -z "$NAME" ]; then
    if [ -z "$1" ]; then
        echo "Please define a database name"
        exit 1
    else
        NAME=$1
    fi
fi

NAME="sarcina" && sudo mysql --user=root --password= --execute="CREATE DATABASE $NAME;CREATE USER $NAME@localhost;SET PASSWORD FOR $NAME@localhost = 'ColorAnimalNumber$';ALTER USER '$NAME'@'localhost' IDENTIFIED WITH mysql_native_password BY 'ColorAnimalNumber$';GRANT ALL PRIVILEGES ON $NAME.* TO $NAME@localhost;FLUSH PRIVILEGES;"
sudo chmod 007 /usr/local/sbin/le-renew-haproxy