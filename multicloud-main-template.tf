# Define your providers
provider "google" {
  credentials = file("<path_to_gcp_credentials_json>")
  project     = "your-gcp-project"
  region      = "us-east4"
}

provider "aws" {
  region = "us-east-1"
}

# Create a Google Kubernetes Engine (GKE) cluster with autoscaling
resource "google_container_cluster" "my_cluster" {
  name     = "my-gke-cluster"
  location = "us-east4-a"
  
  node_config {
    machine_type = "n1-standard-2"
  }

  # Enable node autoscaling
  node_pool {
    initial_node_count = 3
    max_node_count     = 10
    min_node_count     = 3

    node_config {
      machine_type = "n1-standard-2"
    }
  }
}

# Create a Cloud SQL instance for the database
resource "google_sql_database_instance" "my_database_instance" {
  name = "my-cloud-sql-instance"
  database_version = "POSTGRES_12"  # Change to your desired database version
  region = "us-east4"
  settings {
    tier = "db-f1-micro"  # Adjust the tier based on your needs
  }
}

# Create an S3 bucket in AWS for your static website
resource "aws_s3_bucket" "my_website_bucket" {
  bucket = "my-aws-website-bucket"
  acl    = "public-read"  # Adjust the ACL as needed
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

# Output the cluster credentials for kubectl
output "cluster_credentials" {
  value = google_container_cluster.my_cluster.master_auth
}

# Output the Cloud SQL instance connection name
output "sql_instance_connection_name" {
  value = google_sql_database_instance.my_database_instance.connection_name
}

# Output the S3 bucket website endpoint
output "s3_bucket_website_endpoint" {
  value = aws_s3_bucket.my_website_bucket.website_endpoint
}
