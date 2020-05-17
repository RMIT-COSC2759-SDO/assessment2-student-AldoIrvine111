resource "aws_db_subnet_group" "todo-app" {
  name       = "assignment2 db"
  subnet_ids = [aws_subnet.data_az1.id, aws_subnet.data_az2.id, aws_subnet.data_az3.id]

  tags = {
    name = "Assignment2-DB"
  }
}

resource "aws_db_instance" "A2-db" {
  skip_final_snapshot       = true
  engine                    = "postgres"
  engine_version            = "11.4"
  instance_class            = "db.t2.micro"
  allocated_storage         = 15
  storage_type              = "gp2"
  name                      = "postgres"
  username                  = "postgres"
  password                  = "postgres"
  db_subnet_group_name      = aws_db_subnet_group.todo-app.id
  final_snapshot_identifier = "foo"
  identifier                = "postgres"
  vpc_security_group_ids    = [aws_security_group.allow_http_ssh.id]
}

# resource "aws_s3_bucket" "bucket" {
#   bucket = "assingment2"
#   lifecycle {
#     prevent_destroy = true
#   }

#   versioning {
#     enabled = true
#   }

#   tags = {
#     Name = "S3 Assignment2"
#   }
# }

# resource "aws_dynamodb_table" "assignment2db-terraform-state-lock" {
#   name           = "TechTestApp-DynamoDB-table"
#   hash_key       = "LockID"
#   read_capacity  = 20
#   write_capacity = 20

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

#   tags = {
#     name = "Assignment2 Terraform"
#   }
# }


# terraform {
#   backend "s3" {
#     encrypt = true
#     bucket  = "terraformbackend"
#     key     = "terraform"
#     region  = "us-east-1"
#     # dynamodb_table = "TechTestApp-DynamoDB-table"
#   }
# }

