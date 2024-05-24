<h1>How to use Magento INIT?</h1>

1. Download file via `git clone https://github.com/mlipski92/deploy-init.git`
2. Create directory `conf` and place there `env.php` and `config.php` files from `MAGENTO_ROOT/app/etc`
3. Create directory `media` and place there `media` directory
4. Init deploy create via command fired on root folder `sh init.sh`


<h2>Whole deploy proccess:</h2>
1. Local env
On this step new instance on Magento 2 have to be created /Warden.dev recommended
After Warden use file .env have to be checked if there is compatible with official Magento 2 documentation.

2. Create repo on Github
   
3. Create APP on RunCloud panel
<strong>VERY IMPORTANT</strong>: Github repository have to be setup ON THIS STEP, setting up after app creating is unavailable
Make sure that version of PHP for app and console is compatible with Magento 2 official documentation

4. Use Magento INIT

5. Create dabatase

6. Change file env.php

7. Check information:
 - ElasticSearch: `magento config:show catalog/search/engine`
 - Domain `bin/magento config:set web/secure/base_url`, `bin/magento config:set web/unsecure/base_url`
