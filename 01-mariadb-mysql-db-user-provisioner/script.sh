#!/usr/bin/env bash
# description : automate creation of MariaDB/MySQL database and user for services
# date : 2023-03-08


packages=( "mysql" )

# database name
DB_NAME=${"$1":-"demo-bash"}

# database options like character encoding....
DB_OPTIONS=${"$2":-""}
          
# database administrator user
DB_USER=${"$3":-"bash"}

# administrator user password 
DB_USER_PASSWORD=${$4:-"mypassword"}

# network CIDR that user 
NETWORK_CIDR="192.168.1.%"

# check for command line arguments 
if [[ ! $# -eq 4  ]]; then
    echo "Please provide required argument"
    echo "Usage : $0 <db_name> <db_options|""> <db_user> <db_user_password>"
    exit 1 
fi
     
# check for required packages  
for package in $packges; do
	if [[ ! command -v $package ]]; then
    	echo "Please install $package."
        exit 2
    fi
done

# create database
mysql -u root -e "CREATE DATABASE $DB_NAME '$DB_OPTIONS';"

# create administrator user 
mysql -u root -e "CREATE USER '$DB_USER'@'$NETWORK_CIDR' INDENTIFIED BY '$DB_USER_PASSWORD';"

# granting all database permissions to the user. 
mysql -u root -e "GRANT ALL PRIVILEGES ON '$DB_NAME'.* TO '$DB_USER'@'$NETWORK_CIDR' IDENTIFIED BY '$DB_USER_PASSWORD';"

mysql -u root -e "FLUSH PRIVILEGES;"
