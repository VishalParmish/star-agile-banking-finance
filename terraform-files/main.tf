resource "aws_instance" "test-server" {
  ami = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  key_name = "firstkey"
  vpc_security_group_ids = ["sg-0ca482665840628e1"]
  connection {
     type = "ssh"
     user = "ubuntu"
     private_key = file("./firstkey.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/Banking-Finance/terraform-files/ansibleplaybook.yml"
     }
  }
