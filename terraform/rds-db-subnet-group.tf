resource "aws_db_subnet_group" "database-subnets" {
  name        = "database subnets"
  description = "database subnets"
  subnet_ids  = [aws_subnet.priv-data-subnet-az1.id, aws_subnet.priv-data-subnet-az2.id]
}