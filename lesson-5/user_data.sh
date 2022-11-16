#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y


myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

#sudo mkdir /var/www
#sudo mkdir /var/www/html
#sudo touch /var/www/html/index.html
cat <<EOF > /var/www/html/index.html
<html>
<body bgcolor="black">
<h2>TextTexText from: $myip <font color="red"> TextTexText </font></h2><br>
<font color="green">123321 <font color="aqua">$myip<br><br>


<font color="magenta">
<b> Version 2.0 </b>
</body>
</html>
EOF

sudo service httpd start
chkconfig httpd on
