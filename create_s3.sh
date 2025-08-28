#!/bin/bash

set -euo pipefail

check_aws() {
    if ! command -v aws &> /dev/null; then
        echo "AWS CLI is not installed."
        install_aws
    else
        echo "AWS CLI is already installed."
    fi
}

install_aws() {
    echo "Installing AWS CLI v2 on this device."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    sudo apt-get install -y unzip &> /dev/null
    unzip awscliv2.zip
    sudo ./aws/install
    aws --version
    rm -rf awscliv2.zip
}


create_s3() {
    bucket_name="mynewbucket-1234567778"
    region="us-east-2"

    echo "Checking for bucket: $bucket_name in region: $region"

    aws s3 ls "s3://$bucket_name" --region "$region" || {
        echo "Bucket does not exist: '$bucket_name' or you do not have access."
        return
    }

    echo "Contents of S3 bucket '$bucket_name':"
    aws s3 ls "s3://$bucket_name" --region "$region"
}

# Main execution
echo "Running the script..."
check_aws
create_s3


