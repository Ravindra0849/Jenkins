terraform {
    backend "s3" {
        bucket         = "demo-ravindra-123"
        key            = "s3/terraform.tfstate"   # Partion key should be LockID
        region         = "ap-south-1"
        dynamodb_table = "demo-ravindra-123"
    }
}