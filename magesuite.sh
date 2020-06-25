#https://github.com/magesuite/magesuite
docker exec -it my-magento composer require creativestyle/magesuite ^5.0.0
docker exec -it my-magento bin/magento setup:upgrade
# ./copyfromcontainer.sh
cd app/vendor/creativestyle/theme-creativeshop
yarn
yarn build