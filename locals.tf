locals {
  name   = "bk-sql"
  port   = "3306"
  tags = {
    Owner       = "balkrishna"
    Environment = "dev"
    tool = "terraform"
  }
}