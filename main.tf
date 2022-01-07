##################################################################################
# TERRAFORM CONFIG
##################################################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

  }
}

##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  region = var.aws_region
}


##################################################################################
# VARIABLES
##################################################################################


variable "aws_region" {
  type        = string
  description = "Region for AWS Resources"
  default     = "us-east-1"
}

variable "db_name" {
  type        = string
  description = "Region for AWS Resources"
  default     = "mydb"
}

variable "user_name" {
  type = string
  sensitive = true
}

variable "pass_word" {
  type = string
  sensitive = true
}


##################################################################################
# RESOURCES
##################################################################################


resource "aws_db_instance" "bk_db" {
  allocated_storage    = 5
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  identifier           = "bk-db"
  name                 = var.db_name
  username             = var.user_name
  password             = var.pass_word
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true

  depends_on = [
    aws_iam_role.bk_db_iam,
  ]

}

resource "aws_db_instance_role_association" "bk_db_role" {
  db_instance_identifier = aws_db_instance.bk_db.id
  feature_name           = "s3Import"
  role_arn               = aws_iam_role.bk_db_iam.arn

    depends_on = [
    aws_db_instance.bk_db,
  ]
  
}

resource "aws_iam_role" "bk_db_iam" {
  name = "bk_db_iam"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "bk_rds_access_policy" {
    role = "${aws_iam_role.bk_db_iam.name}"
    policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}


##################################################################################
# DATA
##################################################################################


# data "aws_db_instance" "bk_db_data" {
#   db_instance_identifier = "bk-db"
# }


##################################################################################
# OUTPUT
##################################################################################


output "db_ep" {
  value = aws_db_instance.bk_db.endpoint
}

output "db_dn" {
  value = aws_db_instance.bk_db.name
}
