FROM php:7.2.30-apache-buster

ENV INSTALL_DIR /var/www/html
ENV COMPOSER_HOME /usr/local/bin
ENV MAGENTO /bin/magento

RUN requirements="libbz2-dev libfreetype6-dev libicu-dev libjpeg62-turbo-dev libssh2-1-dev libsodium-dev  libmcrypt-dev libpng-dev libpng++-dev libzip-dev libmcrypt-dev libmcrypt4 libjpeg-dev libcurl3-dev libfreetype6 libfreetype6-dev libicu-dev libxslt1-dev libssl-dev lsof default-mysql-client unzip gzip curl git cron" \
    && apt-get -y update \
    && apt-get install -y $requirements \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=DIR \
    && docker-php-ext-install gd \
    pdo_mysql \
    mbstring \
    zip \
    intl \
    xsl \
    soap \
    bcmath \
    sockets \
    curl \
    phar  \
    opcache \
    pcntl \
    gettext \
    bz2 

RUN pecl channel-update pecl.php.net \
  && pecl install xdebug

RUN docker-php-ext-enable xdebug \
  && sed -i -e 's/^zend_extension/\;zend_extension/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get install -y nodejs 

# RUN curl -o- -L https://yarnpkg.com/install.sh | bash
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | bash apt-key add - echo "deb https://dl.yarnpkg.com/debian/ stable main" | bash tee /etc/apt/sources.list.d/yarn.list \
#     && apt-get -y update && apt-get install -y yarn
  
RUN curl -sSLO https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 \
  && chmod +x mhsendmail_linux_amd64 \
  && mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail

RUN curl -sS https://getcomposer.org/installer | \
  php --  --install-dir=$COMPOSER_HOME --filename=composer
COPY ./auth.json $COMPOSER_HOME

RUN echo 127.0.0.1 www.magento.test.com magento.test.com >> "/etc/hosts"
COPY "magento.test.com.conf" "/etc/apache2/sites-available/magento.test.com.conf"
COPY "magento.test.com.conf" "/etc/apache2/sites-enabled/magento.test.com.conf"
COPY "apache2.conf" "/etc/apache2/apache2.conf"
RUN rm -rf "/etc/apache2/sites-available/000-default.conf"
RUN rm -rf "/etc/apache2/sites-available/000-enabled.conf"
RUN rm -rf "/etc/apache2/sites-available/default-ssl.conf"

# VOLUME /var/www
COPY ./php.ini /usr/local/etc/php/php.ini
# COPY ./app  /var/www/html

# RUN  printf '* */1 * * * php /var/www/html/update/cron.php\n' >> /etc/crontab \
#   && printf '* */1 * * * php /var/www/html/bin/magento cron:run\n' >> /etc/crontab \
#   && printf '* */1 * * * php /var/www/html/bin/magento setup:cron:run\n#\n' >> /etc/crontab \
RUN  service cron start  
RUN a2enmod rewrite
WORKDIR $INSTALL_DIR


