provider "aws" {
  region = "us-east-1"   # Replace with your desired AWS region
}

resource "aws_instance" "wordpress" {
  ami           = "ami-0c55b159cbfafe1f0"   # Replace with the appropriate AMI for your region (Ubuntu 20.04 LTS, for example)
  instance_type = "t2.micro"
  key_name      = "key_wordpress"      # Replace with your existing EC2 key pair name
  tags = {
    Name = "wordpress-instance"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y apache2 php libapache2-mod-php php-mysql",
      "sudo service apache2 start",
    ]
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "wordpress-db-subnet-group"
  subnet_ids = aws_subnet.private.*.id
}

resource "aws_security_group" "db" {
  name_prefix = "wordpress-db-sg"
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "dbwordpress" {
  engine           = "mysql"
  instance_class   = "db.t2.micro"
  allocated_storage = 20
  db_name = "dbwordpress"
  username         = "dbadmin"
  password         = "sa453fgsd23"     # Replace with your desired database password
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.db.id]
  tags = {
    Name = "dbwordpress"
  }
}

output "public_ip" {
  value = aws_instance.wordpress.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.wordpress.endpoint
}

resource "aws_efs_mount_target" "alpha" {
  file_system_id = aws_efs_file_system.foo.id
  subnet_id      = aws_subnet.alpha.id
}

resource "aws_vpc" "foo" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "alpha" {
  vpc_id            = aws_vpc.foo.id
  availability_zone = "us-west-2a"
  cidr_block        = "10.0.1.0/24"
}

resource "aws_efs_file_system" "foo" {
  creation_token = "efs_wordpress"

  tags = {
    Name = "efs_wordpress"
  }
}
