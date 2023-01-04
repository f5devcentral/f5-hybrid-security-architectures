# Create SSH Key Pair
resource "aws_key_pair" "app-server" {
  key_name   = format("%s-app-server-key-%s", local.project_prefix, local.build_suffix)
  public_key = var.ssh_key
}
resource "aws_instance" "app-server" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"

  root_block_device {
    volume_size = 8
  }

  user_data = <<-EOF
    #!/bin/bash
    set -ex
    sudo yum update -y
    sudo amazon-linux-extras install docker -y
    sudo service docker start
    sudo usermod -a -G docker ec2-user
    sudo curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker pull bkimminich/juice-shop
    docker run -d -p 80:3000 bkimminich/juice-shop
  EOF
  
  vpc_security_group_ids = [local.internal_sg_id]
  subnet_id = values(aws_subnet.app-subnet)[0].id

  iam_instance_profile = aws_iam_instance_profile.ec2_profile_juice_shop.name

  tags = {
    Name  = format("%s-app-server-%s", local.project_prefix, local.build_suffix)
    Owner = local.resource_owner
  }
  key_name = aws_key_pair.app-server.key_name
  monitoring              = true
  disable_api_termination = false
  ebs_optimized           = true
}