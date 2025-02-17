resource "aws_instance" "web" {
 ami     = "ami-0f3c7d07486cad139"
 instance_type = "t2.micro"
 vpc_security_group_ids = aws_security_group.roboshop-all.id
 
 tags = {
    name = "provisioner"
 }
 provisioner "local-exec" {
   command = "echo this will execute at the time of creation, you can trigger other system like email and sending alert" # self = aws_instance.web
 }

 provisioner "local-exec" {
   command = "echo ${self.private_ip} > inventory" # self = aws_instance.web
 }

#   provisioner "local-exec" {
#    command = "anisble-playbook -i inventory web.yaml" # self = aws_instance.web
#  }

  provisioner "local-exec" {
   when = destroy
   command = "echo this will execute at the time of creation, you can trigger other system like email and sending alert" # self = aws_instance.web
 }

 connection {
   type = "ssh"
   user = "centos"
   password = "DevOps321"
   host = self.public_ip
 }

 provisioner "remote-exec" {
   inline = [
     "echo 'this is from remote exec' > /tmp/remote.txt",
     "sudo yum install nginx -y",
     "sudo systemctl start nginx"
   ]
 }
}

resource "aws_security_group" "roboshop-all" { 
   name        = "provisioner"

   ingress {
      description      = "Allow all ports"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      
   }

   ingress {
      description      = "Allow all ports"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      
   }
    egress {
          from_port      = 0
          to_port        = 0
          protocol       = "-1"
          cidr_blocks    = ["0.0.0.0/0"]
          #ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        name = "provisioner"
    }
}
