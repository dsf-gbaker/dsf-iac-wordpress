## Key Pair
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "wordpress-keypair" {
  key_name    = "wordpress-access-key"
  public_key  = tls_private_key.key.public_key_openssh
}

resource "aws_ebs_volume" "wordpress" {
  availability_zone = var.availability-zone
  size = var.ebs-data-size
  
  tags = {
    Type = "data"
  }
}

resource "aws_ebs_snapshot" "wordpress" {
  volume_id = aws_ebs_volume.wordpress.id
}

resource "aws_volume_attachment" "wordpress" {
  device_name = var.ebs-data-device-name
  volume_id   = aws_ebs_volume.wordpress.id
  instance_id = aws_instance.wordpress.id

  stop_instance_before_detaching = true
}

resource "aws_instance" "wordpress" {
  ami                         = var.ami
  availability_zone           = var.availability-zone
  instance_type               = "t4g.micro"
  subnet_id                   = data.terraform_remote_state.dsf.outputs.public_subnet_id2
  key_name                    = aws_key_pair.wordpress-keypair.key_name
  associate_public_ip_address = true

  user_data = templatefile("../scripts/startup.tftpl", {
    datadir:        "/wordpress/data",
    datadevicename: var.ebs-data-device-name,
    fstype:         var.ebs-data-fstype,
    dbprefix:       var.wp-prefix,
    dbname:         var.wp-dbname,
    dbuser:         var.wp-dbuser,
    dbpwd:          var.wp-dbpwd,
    dbhost:          data.terraform_remote_state.dsf.outputs.rds_endpoint
  })

  vpc_security_group_ids = [
    data.terraform_remote_state.dsf.outputs.security_group_id
  ]

  root_block_device {
    volume_size           = "8" # GiB
    volume_type           = "gp2"
    delete_on_termination = true
  }
}