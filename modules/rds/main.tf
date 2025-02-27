resource "aws_db_subnet_group" "this" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name = "${var.db_name}-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "13.7"
  instance_class          = "db.t3.micro"
  name                    = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = var.db_security_group_ids
  skip_final_snapshot     = true
  publicly_accessible     = false
  tags = {
    Name = "${var.db_name}-rds"
  }
}