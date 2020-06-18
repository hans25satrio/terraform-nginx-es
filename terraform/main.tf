resource "aws_key_pair" "terraform_ec2_key" {
  key_name   = "hans-key"
  public_key = "{Dummy}ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD2MQ4+fdSnSSR5NfwjIxygj5N6EH9GFMTuWlYJpgU3jjtIwa/YeOfVXJ6FqxwEuj6M4rHzLnRItbJ9uLuaM72JgQUsiFjRPF0RS0AZdJ5jqKxAhxlnxaYYhXMxWPtRuCCfYDQ5HxU0osqB+Z8gRgnUyEOQo0MUBYwe9+6OefnvSsa2cmYq43Rq+qnORjk1NSFz+ZSq09XTUdrT+iatK6Z1TvAY+AFDP4AEzld9rzPsJCOhxYB9mcHT+sL1GQfOZ0wi8owXJVK9lOYhA1mRSeUDmAyUpAVn44E8uJ2oX0troO5Qe/3N8wy6klk0/Y5yDp7mE1yHVvN6fw9KJMXJeSCP hans.dummy"
}

resource "aws_instance" "hans-es" {
  ami                         = "ami-04763b3055de4860b" #ubuntu16
  instance_type               = "t2.micro"
  private_ip                  = "172.28.0.6"
  associate_public_ip_address = "true"
  subnet_id                   = aws_subnet.publicES.id
  vpc_security_group_ids      = ["${aws_security_group.hansessg.id}"]
  key_name                    = "hans-key"
  tags = {
    Name = "Hans ES"
  }
  connection {
    type        = "ssh"
    host        = aws_instance.hans-es.public_ip
    user        = "ubuntu"
    private_key = file("pem/hans-key")

  }

  provisioner "remote-exec" {
    inline = [
      "mkdir /home/ubuntu/docker-needs"
    ]
  }
  provisioner "file" {
    source      = "../install-docker.sh"
    destination = "/home/ubuntu/install-docker.sh"
  }
  provisioner "file" {
    source      = "../elasticsearch.yml"
    destination = "/home/ubuntu/docker-needs/elasticsearch.yml"
  }
  provisioner "file" {
    source      = "../Dockerfile-elastic"
    destination = "/home/ubuntu/docker-needs/Dockerfile-elastic"
  }
  provisioner "file" {
    source      = "../docker-compose-elastic.yml"
    destination = "/home/ubuntu/docker-needs/docker-compose-elastic.yml"
  }
  provisioner "file" {
    source      = "../docker-entrypoint.sh"
    destination = "/home/ubuntu/docker-needs/docker-entrypoint.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/install-docker.sh",
      "/bin/sh -c /home/ubuntu/install-docker.sh",
      "cd docker-needs",
      "sudo docker-compose -f docker-compose-elastic.yml up --build -d"
    ]
  }

}

resource "aws_instance" "hans-nginx" {
  ami                         = "ami-04763b3055de4860b" #ubuntu16
  instance_type               = "t2.micro"
  private_ip                  = "172.28.0.5"
  associate_public_ip_address = "true"
  subnet_id                   = aws_subnet.publicES.id
  vpc_security_group_ids      = ["${aws_security_group.hansnginxsg.id}"]
  key_name                    = "hans-key"
  tags = {
    Name = "Hans Nginx"
  }
  connection {
    type        = "ssh"
    host        = aws_instance.hans-nginx.public_ip
    user        = "ubuntu"
    private_key = file("pem/hans-key")

  }

  provisioner "remote-exec" {
    inline = [
      "mkdir /home/ubuntu/docker-needs",
      "mkdir /home/ubuntu/certs"
    ]
  }

  provisioner "file" {
    source      = "../install-docker.sh"
    destination = "/home/ubuntu"
  }
  provisioner "file" {
    source      = "../nginx.conf"
    destination = "/home/ubuntu/docker-needs"
  }
  provisioner "file" {
    source      = "../Dockerfile-nginx"
    destination = "/home/ubuntu/docker-needs"
  }
  provisioner "file" {
    source      = "../docker-compose-nginx.yml"
    destination = "/home/ubuntu/docker-needs"
  }
  provisioner "file" {
    source      = "../certs/hans.crt"
    destination = "/home/ubuntu/certs"
  }
  provisioner "file" {
    source      = "../certs/hans.key"
    destination = "/home/ubuntu/certs"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/install-docker.sh",
      "/bin/sh -c /home/ubuntu/install-docker.sh",
      "cd docker-needs"
      "sudo docker-compose -f docker-compose-nginx.yml up"
    ]
  }
}
