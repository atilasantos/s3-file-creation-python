
resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "platform-challange-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}
