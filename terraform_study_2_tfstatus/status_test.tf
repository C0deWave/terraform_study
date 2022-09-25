terraform {
  backend "s3" {
    key = "global/s3/terraform.tfstatus"
  }
}

provider "aws" {
    region = "ap-northeast-2"
}

resource "aws_s3_bucket" "terraform_status_bucket" {
  bucket = "terraform-up-and-running-state-jmjang"
  # 실수로 인한 삭제 방지
  lifecycle {
    prevent_destroy = false
  }
}

# 버킷 버저닝
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.terraform_status_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 버킷 암호화
resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.terraform_status_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# 상태 락킹을 위한 다이나모DB
resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform-status-locking-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

output "s3_bucker_arn" {
  value = aws_s3_bucket.terraform_status_bucket.arn
  description="terraform_state_s3_arn"
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
  description = "dynamodb_table__terraform_locks_name"
}