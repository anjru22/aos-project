data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "fleetcart-db-creds"
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

resource "aws_db_instance" "rds-db-az1" {
  allocated_storage      = 20
  db_name                = "rds_db_az1"
  engine                 = "mysql"
  multi_az               = false
  identifier             = "rds-db-az1"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  username               = local.db_creds.username
  password               = local.db_creds.password
  snapshot_identifier    = "fleetcart-db"
  db_subnet_group_name   = aws_db_subnet_group.database-subnets.name
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  availability_zone      = "us-west-1a"
  skip_final_snapshot    = true
}