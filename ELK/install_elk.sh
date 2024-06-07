
sudo apt update
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch |sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg

echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.listAA

sudo apt update

sudo apt install elasticsearch

sudo nano /etc/elasticsearch/elasticsearch.yml

. . .
# ---------------------------------- Network -----------------------------------
#
# Set the bind address to a specific IP (IPv4 or IPv6):
#
network.host: localhost
. . .


sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch

curl -X GET "localhost:9200"


# Install Kibana 

sudo apt install kibana
sudo systemctl enable kibana
sudo systemctl start kibana