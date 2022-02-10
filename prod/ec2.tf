## Key Pair
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "wordpress-keypair" {
  key_name    = "wordpress-access-key"
  public_key  = tls_private_key.key.public_key_openssh
}

# find the latest wordpress ami for the desired major v
data "aws_ami" "wordpress" {
  owners      = ["self"]
  most_recent = true
  
  filter {
    name    = "name"
    values  = [
      "wordpress-v${var.wordpress-major-v}.*"
    ]
  }
}

resource "aws_instance" "wordpress" {
  ami                         = data.aws_ami.wordpress.id
  availability_zone           = var.availability-zone
  instance_type               = "t4g.micro"
  subnet_id                   = data.terraform_remote_state.dsf.outputs.public_subnet_id2
  key_name                    = aws_key_pair.wordpress-keypair.key_name
  associate_public_ip_address = true

  user_data = templatefile("../scripts/startup.tftpl", {
    wpdir:          "/var/www/html"
    dbprefix:       var.wp-prefix,
    dbname:         var.wp-dbname,
    dbuser:         var.wp-dbuser,
    dbpwd:          var.wp-dbpwd,
    dbhost:         data.terraform_remote_state.dsf.outputs.rds_endpoint
  })

  vpc_security_group_ids = [
    data.terraform_remote_state.dsf.outputs.security_group_id
  ]

  root_block_device {
    volume_size           = "10" # GiB
    volume_type           = "gp2"
    delete_on_termination = false
  }
}