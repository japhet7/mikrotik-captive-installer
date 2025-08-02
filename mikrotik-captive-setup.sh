#!/bin/bash
# AUTO-INSTALL: Mikrotik Captive Portal Full Setup
# Ubuntu 20.04.6 LTS + MikroTik RouterOS 7
# Features: RadiusDesk + CoovaChilli + Modern Web Login + SMS/WhatsApp + Payment Gateway Placeholders

set -e

echo "[1/7] Updating System Packages..."
apt update && apt upgrade -y

echo "[2/7] Installing Web & DB Stack..."
apt install -y apache2 php php-mysql mariadb-server mariadb-client git unzip curl php-curl php-mbstring php-xml php-zip php-gd

systemctl enable apache2
systemctl enable mariadb
systemctl start apache2
systemctl start mariadb

mysql_secure_installation <<EOF
n
y
y
y
y
EOF

mysql -uroot -e "CREATE DATABASE radius;"
mysql -uroot -e "CREATE USER 'radius'@'localhost' IDENTIFIED BY 'radiuspass';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON radius.* TO 'radius'@'localhost';"
mysql -uroot -e "FLUSH PRIVILEGES;"

echo "[3/7] Installing FreeRADIUS..."
apt install -y freeradius freeradius-mysql
systemctl enable freeradius
systemctl start freeradius

echo "[4/7] Installing CoovaChilli..."
apt install -y coovachilli
systemctl enable coovachilli

echo "[5/7] Installing RadiusDesk..."
cd /var/www/html
rm -f index.html
wget https://github.com/radiusdesk/radiusdesk/archive/refs/heads/master.zip -O radiusdesk.zip
unzip radiusdesk.zip && mv radiusdesk-master radiusdesk
chown -R www-data:www-data radiusdesk

cat <<EOF >/etc/apache2/sites-available/radiusdesk.conf
<VirtualHost *:80>
    DocumentRoot /var/www/html/radiusdesk
    <Directory "/var/www/html/radiusdesk">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

a2dissite 000-default.conf
a2ensite radiusdesk.conf
systemctl reload apache2

echo "[6/7] Setting Up Captive Portal Page..."
mkdir -p /var/www/html/hotspotlogin
cat <<EOL > /var/www/html/hotspotlogin/index.html
<!DOCTYPE html>
<html lang=\"en\">
<head>
  <meta charset=\"UTF-8\">
  <title>Hotspot Login</title>
  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
  <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css\">
</head>
<body class=\"bg-light d-flex justify-content-center align-items-center\" style=\"height: 100vh\">
  <div class=\"card p-4 shadow-lg rounded\">
    <h4 class=\"mb-3\">Welcome to WiFi</h4>
    <form method=\"POST\" action=\"/login/auth\">
      <input class=\"form-control mb-3\" name=\"username\" placeholder=\"Enter Voucher Code\" required>
      <button class=\"btn btn-primary w-100\">Connect</button>
    </form>
    <hr>
    <a href=\"#\" class=\"btn btn-success w-100 mb-2\">Pay with M-Pesa</a>
    <a href=\"https://wa.me/yourwhatsappnumber\" class=\"btn btn-outline-success w-100\">Chat on WhatsApp</a>
  </div>
</body>
</html>
EOL

chown -R www-data:www-data /var/www/html/hotspotlogin

echo "[7/7] Installation Finished!"
echo "---------------------------------------"
echo "RadiusDesk:     http://<your-vps-ip>/radiusdesk"
echo "Login Portal:   http://<your-vps-ip>/hotspotlogin"
echo "---------------------------------------"
echo "[NEXT] Configure MikroTik to use this VPS as Radius server."
echo "[TODO] Integrate M-Pesa, PayPal, Selcom, PesaPal APIs."
echo "[TODO] Add SMS/WhatsApp Auto-Voucher Scripts."
echo "[NOTE] Replace <your-vps-ip> with actual IP/domain."
echo "---------------------------------------"
