#!/bin/bash

# Instalacja Elasticsearch
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elastic-7.x.list'
sudo apt update
sudo apt install elasticsearch -y
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch

# Instalacja Logstash
sudo apt install logstash -y

# Konfiguracja Logstash
sudo tee /etc/logstash/conf.d/02-beats-input.conf > /dev/null <<EOL
input {
  beats {
    port => 5044
  }
}
EOL

sudo tee /etc/logstash/conf.d/10-syslog-filter.conf > /dev/null <<EOL
filter {
  if [fileset][module] == "apache" {
    if [fileset][name] == "access" {
      grok {
        match => { "message" => "%{COMMONAPACHELOG}" }
      }
      date {
        match => [ "timestamp" , "dd/MMM/yyyy:HH:mm:ss Z" ]
      }
      geoip {
        source => "clientip"
      }
    }
    else if [fileset][name] == "error" {
      grok {
        match => { "message" => "%{APACHE_ERRORLOG}" }
      }
    }
  }
}
EOL

sudo tee /etc/logstash/conf.d/30-elasticsearch-output.conf > /dev/null <<EOL
output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
    manage_template => false
    index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
  }
}
EOL

sudo systemctl restart logstash
sudo systemctl enable logstash

# Instalacja Kibana
sudo apt install kibana -y
sudo systemctl start kibana
sudo systemctl enable kibana

echo "ELK stack has been installed and configured."
