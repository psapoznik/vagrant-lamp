#!/usr/bin/env bash
function setup_xdebug() {
    cd /usr/lib
    if [ -d /usr/lib/xdebug ]; then
        rm -rf xdebug
    fi
    git clone git://github.com/xdebug/xdebug.git
    cd xdebug

    /opt/phpfarm/inst/php-$1/bin/phpize
    ./configure --with-php-config=/opt/phpfarm/inst/php-$1/bin/php-config
    make
    make install
    if [[ $1 == *"5.4"* ]] ; then
        cat /vagrant/files/xdebug-5.4.txt >> /opt/phpfarm/inst/php-$1/etc/php.ini
    else
        cat /vagrant/files/xdebug.txt >> /opt/phpfarm/inst/php-$1/etc/php.ini
    fi
}


# Setup PHPFARM
cd /opt
if [ ! -d /opt/phpfarm ]; then
    git clone https://github.com/DemacMedia/phpfarm.git phpfarm
fi

# PHP 5.4
if [ ! -f /opt/phpfarm/inst/php-5.4.45/bin/php ]; then
    cd /opt/phpfarm/src
    ./main.sh 5.4.45
    setup_xdebug 5.4.45
    #PHP 5.4 uses lib instead of etc for php.ini
    mv /opt/phpfarm/inst/php-5.4.45/etc/php.ini /opt/phpfarm/inst/php-5.4.45/lib/php.ini
fi
if [ ! -f /opt/phpfarm/inst/php-5.4.45/etc/php-fpm.conf ]; then
    cp /vagrant/files/php-fpm-5.4.conf /opt/phpfarm/inst/php-5.4.45/etc/php-fpm.conf
fi
if [ ! -f /etc/init.d/php-5.4 ]; then
    cp /vagrant/files/php-init.d-5.4.sh /etc/init.d/php-5.4
    chmod +x /etc/init.d/php-5.4
    update-rc.d php-5.4 defaults
fi

# PHP 5.5
if [ ! -f /opt/phpfarm/inst/php-5.5.34/bin/php ]; then
    cd /opt/phpfarm/src
    ./main.sh 5.5.34
    setup_xdebug 5.5.34
fi
if [ ! -f /opt/phpfarm/inst/php-5.5.34/etc/php-fpm.conf ]; then
    cp /vagrant/files/php-fpm-5.5.conf /opt/phpfarm/inst/php-5.5.34/etc/php-fpm.conf
fi
if [ ! -f /etc/init.d/php-5.5 ]; then
    cp /vagrant/files/php-init.d-5.5.sh /etc/init.d/php-5.5
    chmod +x /etc/init.d/php-5.5
    update-rc.d php-5.5 defaults
fi

# PHP 5.6
if [ ! -f /opt/phpfarm/inst/php-5.6.20/bin/php ]; then
    cd /opt/phpfarm/src
    ./main.sh 5.6.20
    setup_xdebug 5.6.20
fi
if [ ! -f /opt/phpfarm/inst/php-5.6.20/etc/php-fpm.conf ]; then
    cp /vagrant/files/php-fpm-5.6.conf /opt/phpfarm/inst/php-5.6.20/etc/php-fpm.conf
fi
if [ ! -f /etc/init.d/php-5.6 ]; then
    cp /vagrant/files/php-init.d-5.6.sh /etc/init.d/php-5.6
    chmod +x /etc/init.d/php-5.6
    update-rc.d php-5.6 defaults
fi

# PHP 7
if [ ! -f /opt/phpfarm/inst/php-7.0.5/bin/php ]; then
    cd /opt/phpfarm/src
    ./main.sh 7.0.5
    setup_xdebug 7.0.5
fi
if [ ! -f /opt/phpfarm/inst/php-7.0.5/etc/php-fpm.d/www.conf ]; then
    cp /vagrant/files/php-fpm-7.conf /opt/phpfarm/inst/php-7.0.5/etc/php-fpm.d/www.conf
fi
if [ ! -f /etc/init.d/php-7 ]; then
    cp /vagrant/files/php-init.d-7.sh /etc/init.d/php-7
    chmod +x /etc/init.d/php-7
    update-rc.d php-7 defaults
fi

# Add PHPFarm to PATH
if ! grep -q "phpfarm" /etc/environment ; then
    echo "PATH="$PATH:/opt/phpfarm/inst/bin:/opt/phpfarm/inst/current/bin:/opt/phpfarm/inst/current/sbin"" >> /etc/environment
fi

#set Default Php
/opt/phpfarm/inst/bin/switch-phpfarm 5.6.20