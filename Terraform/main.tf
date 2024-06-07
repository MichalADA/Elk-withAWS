provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "apache_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = "ApacheServer"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apache2",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2",
      "echo '<html><body><h1>Statyczna Strona HTML</h1></body></html>' | sudo tee /var/www/html/index.html"
    ]
  }

  security_groups = [aws_security_group.allow_http.name]
}

resource "aws_instance" "elk_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = "ELKServer"
  }

  security_groups = [aws_security_group.allow_elk.name]
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
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
