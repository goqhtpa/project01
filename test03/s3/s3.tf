resource "aws_dynamodb_table" "terraform-locks" {
    name = "project01-test03-terraform-locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }
}