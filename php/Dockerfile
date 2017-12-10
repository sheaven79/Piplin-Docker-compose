FROM php:7.1-fpm-alpine

LABEL version="1.0"
LABEL maintainer="Sheaven <sheaven@qq.com>"

RUN mkdir -p /var/www/piplin
WORKDIR /var/www/piplin

RUN sed -i "s/dl-cdn.alpinelinux.org/mirror.tuna.tsinghua.edu.cn/" /etc/apk/repositories

# PHP 环境安装
RUN set -xe \
    && apk add --no-cache \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install pdo_mysql gd zip

# 安装 composer
RUN set -xe \
    && php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && rm -f composer-setup.php \
    && mv composer.phar /usr/local/bin/composer \
    && composer config -g repo.packagist composer https://packagist.phpcomposer.com

# 安装项目依赖
RUN set -xe \
    && apk add --no-cache redis nodejs supervisor git mysql-client bash openssh-client rsync \
    && npm config set registry http://registry.npm.taobao.org/ \
    && mkdir -p /etc/supervisor/conf.d \
    && echo '* * * * * /usr/bin/php /var/www/piplin/artisan schedule:run >> /dev/null 2>&1' > /etc/crontabs/root
COPY supervisor/supervisord.conf /etc/supervisor/supervisord.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 9000 7001

CMD ["/usr/local/bin/entrypoint.sh"]