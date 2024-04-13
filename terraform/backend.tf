terraform {
  backend "s3" {
    bucket         = "mthamilton"
    key            = "terraform/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "terraform-state-lock"
  }
}