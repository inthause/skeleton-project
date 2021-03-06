#!/bin/sh
php sys/composer.phar self-update
php sys/composer.phar update

mkdir tmp
mkdir -p App/Modules/Project/Sampledata
rm -rf App/Modules/Project/Sampledata
git clone https://github.com/inthause/Project_Sampledata.git App/Modules/Project/Sampledata

mysql -u root -pchange -e "drop database IF EXISTS rbschange; create database rbschange;"
rm -rf App/Config/project.autogen.json App/Storage Compilation/* tmp/ log/project/* log/other/*
rm -rf www/Assets www/Imagestorage www/index.php www/admin.php www/rest.php www/rest.V1.php www/ajax.V1.php www/ajax.php

php bin/change.phar change:set-document-root www
php bin/change.phar change:generate-db-schema
php bin/change.phar change:register-plugin --all
php bin/change.phar change:compile-i18n
php bin/change.phar change:install-package --vendor=Rbs Core
php bin/change.phar change:install-package --vendor=Rbs ECom
php bin/change.phar change:install-plugin --type=module --vendor=Rbs Event
php bin/change.phar change:install-plugin --type=module --vendor=Rbs Dev
php bin/change.phar change:install-plugin --type=module --vendor=Rbs Be2bill
php bin/change.phar change:install-plugin --type=module --vendor=Rbs Highlight
php bin/change.phar change:install-plugin --type=module --vendor=Rbs Mondialrelay
php bin/change.phar change:install-plugin --type=theme --vendor=Rbs Base
php bin/change.phar change:install-plugin --type=theme --vendor=Rbs Common
php bin/change.phar change:install-plugin --type=theme --vendor=Rbs Demo

php bin/change.phar change:install-plugin --type=module --vendor=Project Sampledata

php bin/change.phar rbs_website:add-default-website --baseURL="http://localhost:8092/"
php bin/change.phar rbs_user:add-user no-reply@proximis.com admin --realms=Rbs_Admin,web --is-root=true --password=admin
php bin/change.phar rbs_mail:install-mails Rbs_Common_Mail
php bin/change.phar change:compile-i18n
php bin/change.phar change:clear-cache

crontab -u vagrant sys/crontab.default