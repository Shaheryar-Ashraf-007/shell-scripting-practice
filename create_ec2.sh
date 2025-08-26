#!/bin/bash

set -euo pipefail

check_awscli() {
    if ! command -v aws &> /dev/null; then
        echo "AWS CLI is not installed. Installing it now..."
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

waiting_instance() {
    local instance_id="$1"
    echo "Waiting for instance $instance_id to be in running state."
    while true; do
        state=$(aws ec2 describe-instances --instance-ids "$instance_id" --query 'Reservations[0].Instances[0].State.Name' --output text)
        if [[ "$state" == "running" ]]; then
            echo "Instance $instance_id is running."
            break
        fi
        sleep 10
    done
}

create_ec2() {
    local ami_id="$1"
    local instance_type="$2"
    local key_name="$3"
    local subnet_id="$4"
    local security_group="$5"
    local instance_name="$6"

    instance_id=$(aws ec2 run-instances \
        --image-id "$ami_id" \
        --instance-type "$instance_type" \
        --key-name "$key_name" \
        --subnet-id "$subnet_id" \
        --security-group-ids "$security_group" \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance_name}]" \
        --query 'Instances[0].InstanceId' \
        --output text)

    if [[ -z "$instance_id" ]]; then
        echo "There is no instance." >&2
        exit 1
    fi
    echo "Instance created $instance_id successfully."
    waiting_instance "$instance_id"
}

main() {
    check_awscli
    AMI_ID="ami-0d1b5a8c13042c939"             # Specify the AMI ID
    INSTANCE_TYPE="t2.micro" # Specify the instance type
    KEY_NAME="practice-key"              # Specify the key name
    SUBNET_ID="subnet-01fdc804b4adc93a1"             # Specify the subnet ID
    SECURITY_GROUP="sg-0e4c8d49ca77b58c5"        # Specify the security group
    INSTANCE_NAME="test-instance"
    
    create_ec2 "$AMI_ID" "$INSTANCE_TYPE" "$KEY_NAME" "$SUBNET_ID" "$SECURITY_GROUP" "$INSTANCE_NAME"

    echo "Instance created successfully."
}

main
