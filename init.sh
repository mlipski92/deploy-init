echo "Init... Please wait!"
RED='\033[0;31m'
UGreen='\033[4;32m'
NC='\033[0m'
CURRECT_PATH=`pwd`

echo "Configuration files coping..."
if [ -e conf/config.php ]
then
    echo "${UGreen}File config.php catched successfully!${NC}"
else
    echo "${RED}Warning! File config.php is missing!${NC}"
    return
fi

if [ -e conf/env.php ]
then
    echo "${UGreen}File env.php catched successfully!${NC}"
else
    echo "${RED}Warning! File env.php is missing!${NC}"
    return
fi

echo "Creating directories..."
mkdir -p shared/app/etc
mkdir -p shared/pub
mkdir repo
mkdir releases

echo "Coping configuration files..."
cp conf/config.php shared/app/etc/config.php
cp conf/env.php shared/app/etc/env.php

echo "Coping media files..."
cp -r media/media shared/pub

echo $CURRECT_PATH

cat <<EOF >deploy.sh
LATEST="\$(date +"%Y%m%d%H%M%S")"
echo "\$USER deploying \$LATEST"
cd repo || exit 1

git fetch || exit 1
git merge || exit 1
git submodule update --init
cd ..

mkdir releases/\$LATEST
cp repo/* releases/\$LATEST/ -r
cp shared/app/etc/env.php releases/\$LATEST/app/etc/env.php -r
mkdir releases
cp shared/app/etc/config.php releases/\$LATEST/app/etc/config.php -r
rm -rf releases/\$LATEST/pub/media; ln -s $CURRECT_PATH/shared/pub/media $CURRECT_PATH/releases/\$LATEST/pub/media

cd releases/\$LATEST
rm -rf vendor/

php /usr/sbin/composer update
php /usr/sbin/composer install

find ./var -type d -exec chmod 777 {} \;
find ./pub/media -type d -exec chmod 777 {} \;
find ./pub/static -type d -exec chmod 777 {} \;

php -dmemory_limit=1G bin/magento setup:upgrade || { echo "Error while triggering the update scripts using magento-cli" ; exit 1; }

php -dmemory_limit=1G bin/magento setup:di:compile
php -dmemory_limit=1G bin/magento setup:static-content:deploy -f

cd ../..
rm -rf current; ln -s releases/\$LATEST current
cd current
bin/magento c:f
EOF

clear
echo "${UGreen}Deployment enviroment created successfully!${NC}"
rm -rf conf
rm -rf media