resource "aws_dynamodb_table" "db_table" {
  name         = "Hit_Count"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Hit"

  attribute {
    name = "Hit"
    type = "S"
  }

  tags = var.common_tags
}

resource "aws_dynamodb_table_item" "db_table_item" {
  table_name = aws_dynamodb_table.db_table.name
  hash_key   = aws_dynamodb_table.db_table.hash_key

  item = <<ITEM
{
  "Hit": {"S": "Counter"},
  "Count": {"N": "0"}
}
ITEM
}
