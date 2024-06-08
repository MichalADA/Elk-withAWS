#!/bin/bash

# Zmienna adresu IP serwera Logstash
LOGSTASH_SERVER_IP="your_logstash_server_ip"  
# zmienic na adres IP 

# Instalacja Filebeat
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elastic-7.x.list'
sudo apt update
sudo apt install filebeat -y

# Konfiguracja Filebeat
sudo tee /etc/filebeat/filebeat.yml > /dev/null <<EOL
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/apache2/access.log
    - /var/log/apache2/error.log

output.logstash:
  hosts: ["$LOGSTASH_SERVER_IP:5044"]
EOL

# Włączanie i uruchamianie Filebeat
sudo filebeat modules enable apache
sudo filebeat setup
sudo systemctl start filebeat
sudo systemctl enable filebeat

echo "Filebeat has been installed and configured."
