resource "aws_security_group" "paydev_to_redis" {
  name        = "tf-paydev_to_redis"
  description = "Allow inbound traffic from paydev"
  vpc_id      = aws_vpc.mlops.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.mlops.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


resource "aws_security_group" "mlops_default" {
  vpc_id      = "${aws_vpc.mlops.id}"
  name        = "tf-mlops-default"
  description = "mlops-default Security Group"

}