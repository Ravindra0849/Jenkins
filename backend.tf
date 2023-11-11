terraform {
    backend "s3" {
        bucket         = "demo-ravindra-123"
        key            = "my-terraform-environment/main"
        region         = "ap-south-1"
        dynamodb_table = "demo-ravindra-123"
    }
}