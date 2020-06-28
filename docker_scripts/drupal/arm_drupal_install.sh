#!/bin/bash

# Copyright (C) 2020 Alex Wolf
# This file is part of docker-utils <https://gitlab.com/flowalex/docker-utils>.
#
# docker-utils is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# docker-utils is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with docker-utils.  If not, see <http://www.gnu.org/licenses/>.

#Local Drupal Provision Script

echo "Script will install Drupal using a Docker Container"

#The following command is setting up the database, please remeber to change the database name which currently is set as MYSQL-NAME and the root password which is MYSQL-PASSWORD
#docker run --name MYSQL-NAME -e MYSQL_ROOT_PASSWORD=MYSQL-PASSWORD -d mysql:latest

read -rp "Please enter a name for your database: " MYSQLNAME
read -srp "Please enter a password for your database: " MYSQLPASSWORD
read -rp "Please enter the verion you want of the MYSQL docker image: " MYSQL_VERSION

docker run --name $MYSQLNAME -e MYSQL_ROOT_PASSWORD=$MYSQLPASSWORD -d hypriot/rpi-mysql:$MYSQL_VERSION

echo
echo

read -rp "Please enter a name for your Drupal Container: " somedrupal
read -rp "Please enter the verion you want of the MYSQL docker image: " DRUPAL_VERSION
docker run --name $somedrupal --link $MYSQLNAME:mysql -p 8080:80 -e MYSQL_USER=root -e MYSQL_PASSWORD=$MYSQLPASSWORD -d drupal:$DRUPAL_VERSION

clear
echo "Please record this information as it will be used later for installing the Drupal Site"
echo "Your site Docker Container iformation is:

MYSQL Container Name: $MYSQLNAME"

echo

read -p "Do you want to see the username/password for the MYSQL database? y/n: " -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo
    echo "MYSQL USERNAME: root
    MYSQLPASSWORD: $MYSQLPASSWORD"
fi
echo
echo "Drupal Container Name: $somedrupal"

echo " When setting up the database for the drupal site enter the following information:
Database name: drupal
Database Host: $MYSQLNAME"
echo
echo
read -p "Do you want to see the username/password for the MYSQL database? y/n: " -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]] 
then
    echo
    echo "MYSQL USERNAME: root
    MYSQLPASSWORD: $MYSQLPASSWORD"
fi
