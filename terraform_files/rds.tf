module "cluster" {
  count = 1
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 6.1.0"
  name           = join("-", ["portal26-aurora-postgres14", var.tenant_name])
  engine         = "aurora-postgresql"
  engine_version = "14.8"
  instance_class = "db.t3.medium"
  create_random_password = false
  master_username = "postgres"
  master_password = "postgres"
  database_name = "postgres"

  skip_final_snapshot = true

  instances = {
    one = {
      instance_class = "db.t3.medium" 
      writer = true
    }
  }

  vpc_id  = aws_vpc.my_vpc.id
  subnets = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  
  publicly_accessible = true
  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10

  db_parameter_group_name         = "default.aurora-postgresql14"
  db_cluster_parameter_group_name = "default.aurora-postgresql14"

  enabled_cloudwatch_logs_exports = ["postgresql"]
  
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
