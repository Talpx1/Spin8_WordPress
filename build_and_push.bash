#!/bin/bash

read -p "WP Version: " wpversion
read -p "PHP Version: " phpversion
read -p "WebServer Version: " webserverversion

docker build -t talpx1/spin8_wordpress:$wpversion-php$phpversion-$vebserverversion . &&
docker push talpx1/spin8_wordpress:$wpversion-php$phpversion-$vebserverversion