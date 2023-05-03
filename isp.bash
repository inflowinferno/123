#! /bin/bash
# Настраиваем hostname
hostnamectl set-hostname ISP
# Настраиваем репозитории
echo -e "deb http://mirror.yandex.ru/debian bullseye main \ndeb-src http://mirror.yandex.ru/debian bullseye main \ndeb http://mirror.yandex.ru/debian bullseye-updates main \ndeb-src http://mirror.yandex.ru/debian bullseye-updates main \ndeb https://mirror.yandex.ru/debian-security bullseye-security main \ndeb-src https://mirror.yandex.ru/debian-security bullseye-security main" > /etc/apt/sources.list
apt update
# Настраиваем адресацию
echo -e "auto lo \niface lo inet loopback \nauto eth0 \niface eth0 inet dhcp \n\tpost-up /usr/sbin/update-hostname-from-ip \n\tpost-up /usr/share/debian-edu-config/tools/update-proxy-from-wpad" > /etc/network/interfaces
echo "Write IP-address:"
read var_ip
echo "auto eth1 \niface eth1 inet static \naddress $var_ip \nnetmask 255.255.255.0 " >> /etc/network/interfaces
echo "IP-address $var_ip succesfully added to /etc/network/interfaces"
systemctl restart networking
Настраиваем прокси через Apache
a2enmod proxy proxy_http
cat > /etc/apache2/sites-available/koni.demo.wsr.conf <<OL
<VirtualHost *:80>
    ServerName koni.demo.wsr
    ProxyPreserveHost On
    ProxyPass / http://web-l.demo.wsr/
    ProxyPassReverse / http://web-l.demo.wsr/
</VirtualHost>
EOL
a2ensite koni.demo.wsr.conf
systemctl restart apache2
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftp.pem -out /etc/ssl/private/vsftpd.pem


