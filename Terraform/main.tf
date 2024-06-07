provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "apache_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  tags = {
    Name = "ApacheServer"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"  # lub inny użytkownik, np. ec2-user dla Amazon Linux
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "HTML/public_html/"
    destination = "/tmp/public_html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apache2",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2",
      "sudo rm -rf /var/www/html/*",
      "sudo cp -r /tmp/public_html/* /var/www/html/"
    ]
  }

  security_groups = [aws_security_group.allow_http_https.name]
}

resource "aws_instance" "elk_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  tags = {
    Name = "ELKServer"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"  # lub inny użytkownik, np. ec2-user dla Amazon Linux
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }

  security_groups = [aws_security_group.allow_elk.name]
}

resource "aws_security_group" "allow_http_https" {
  name        = "allow_http_https"
  description = "Allow HTTP and HTTPS inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_elk" {
  name        = "allow_elk"
  description = "Allow necessary ELK stack ports"

  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5044
    to_port     = 5044
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
