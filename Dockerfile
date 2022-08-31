FROM almalinux/8-init

LABEL org.opencontainers.image.authors="guilherme.linharees@gmail.com"

RUN dnf -y update \
dnf -y install net-tools wget yum-utils bzip2 unzip tar \
dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm \
dnf -y install 'dnf-command(config-manager)' \
dnf -y config-manager --set-enabled powertools \
dnf -y config-manager --set-enabled remi \
dnf -y module reset php \
dnf -y module install php:remi-7.4 \
dnf -y install yum-plugin-copr && dnf -y copr enable ligenix/enterprise-glpi\
dnf -y install glpi php-pecl-zendopcache php-opcache php-pecl-apcu php-soap php-xmlrpc php-pear-CAS php-snmp php-sodium \
dnf -y install certbot python3-certbot-apache \
systemctl enable --now httpd \
systemctl enable --now firewalld \
systemctl restart firewalld \
firewall-cmd --permanent --zone=public --add-service=http \
firewall-cmd --permanent --zone=public --add-service=https \
firewall-cmd --reload \
setsebool -P httpd_can_sendmail 1 \
setsebool -P httpd_can_network_connect 1 \
setsebool -P httpd_can_network_connect_db 1 \
setsebool -P httpd_mod_auth_ntlm_winbind  1 \
setsebool -P allow_httpd_mod_auth_ntlm_winbind 1 \
rm -f /etc/localtime \
ln -s /usr/share/zoneinfo/America/Fortaleza /etc/localtime \
sed -i 's,;date.timezone =,date.timezone = America/Sao_Paulo,g' /etc/php.ini \
sed -i 's,upload_max_filesize = 2M,upload_max_filesize = 20M,g' /etc/php.ini \
sed -i 's,install,install_ori,g' /etc/httpd/conf.d/glpi.conf \
sed -i 's,#<VirtualHost,<VirtualHost,g' /etc/httpd/conf.d/glpi.conf \
sed -i 's,#  DocumentRoot /usr/share/glpi,  DocumentRoot /usr/share/glpi,g' /etc/httpd/conf.d/glpi.conf \
sed -i 's,#  ServerName glpi.example.com,  ServerName localhost,g' /etc/httpd/conf.d/glpi.conf \
sed -i 's,#</VirtualHost>,</VirtualHost>,g' /etc/httpd/conf.d/glpi.conf \
systemctl restart httpd \
dnf -y update