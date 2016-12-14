#!/bin/bash

if ! type apt-get > /dev/null 2>&1; then
    echo "This script only runs on an apt-get package manager available system"
    exit
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

SYMFONYPATH='/var/www/SymfonyZero'
BRANCH='master'

# Apache
if ! type apache2 > /dev/null 2>&1; then
        sudo printf "${GREEN}Installing apache2:${NC} "
        /bin/bash -c "apt-get install -y apache2;\
                           a2enmod rewrite;\
                           service apache2 restart"
else
        /bin/bash -c "a2enmod rewrite && service apache2 reload"
fi

# PHP and Curl
CURRENT_PHP_VERSION=$(php -v|grep --only-matching --perl-regexp "[5-7]+[.]\d+[.]\d+" | awk '{print $1; exit}');
PHP_VERSION='5.6'
CURRENT_USER=$(echo $SUDO_USER)

function version { echo "$@" | gawk -F. '{ printf("%03d%03d%03d\n", $1,$2,$3); }'; }

if [ "$(version "$CURRENT_PHP_VERSION")" -lt "$(version "$PHP_VERSION")" ]; then
    printf "${GREEN}Installing php:${NC}\n"
    sudo apt-get update -y
    sudo apt-get install software-properties-common python-software-properties -y
    sudo add-apt-repository ppa:ondrej/php -y
    #sudo apt-get install php5 php5-mcrypt libapache2-mod-php5 php5-curl php5-cli php5-mysql php5-gd php5-intl php5-xsl memcached php5-memcache curl -y
    # If you prefer to install php 5.6, comment next line and uncomment the previous one
    sudo apt-get install php7.0 php7.0-mcrypt libapache2-mod-php7.0 php7.0-cli php7.0-fpm php7.0-mysql php7.0-curl php7.0-xml php7.0-intl memcached php-memcached -y
fi

# Git
if ! type git > /dev/null 2>&1; then
	printf "${GREEN}Installing git:${NC} "
	sudo apt-get install -y git
fi

# Check MySQL
if ! type mysql > /dev/null 2>&1; then
    printf "${GREEN}Installing MySQL:${NC} "
    sudo apt-get install -y mysql-server
fi

# Composer
if ! type composer > /dev/null 2>&1; then
    printf "${GREEN}Installing composer:${NC} "
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
fi

# Downloads/Update SymfonyZero 
GIT_ACTION="clone https://github.com/Emergya/SymfonyZero $SYMFONYPATH"
COMPOSER_ACTION="install"

# Update repo and Symfony deploy
git $GIT_ACTION

cd $SYMFONYPATH

printf "${GREEN}Install/Updating vendors:${NC} "
composer $COMPOSER_ACTION
sudo chown -R $CURRENT_USER:$CURRENT_USER $SYMFONYPATH

php bin/console doctrine:database:create
php bin/console doctrine:schema:update --force
php bin/console doctrine:fixtures:load -n
php bin/console cache:clear
php bin/console cache:clear --env=prod
sudo chmod -R 777 $SYMFONYPATH/var/cache
sudo chmod -R 777 $SYMFONYPATH/var/logs
sudo chmod -R 777 $SYMFONYPATH/web/images

printf "${GREEN}Configuring Apache Virtualhost and restarting:${NC} "
# Update and enable Apache2 config
cp $SYMFONYPATH/deploy/symfonyzero.conf /etc/apache2/sites-available/symfonyzero.conf
sudo a2ensite symfonyzero.conf
ln -s /etc/apache2/sites-available/symfonyzero.conf /etc/apache2/sites-enabled
service apache2 restart

#Add entry in /etc/hosts
printf "\n127.0.0.1\tsymfonyzero\n" >> /etc/hosts

#EOP
printf "\n${GREEN}Install completed."
printf "\n--------------------------"
printf "\nIMPORTANT: Developer environment is default enabled so if your"
printf "\ndeployment has been in an LXC container or an external server you "
printf "\nhave to configure the proper values for Production or enable remote "
printf "\naccess to your IP in the app_dev.php file\n\${NC}".
printf "\n${GREEN}For further information, please refer to http://www.symfony.com\n\n${NC}".
