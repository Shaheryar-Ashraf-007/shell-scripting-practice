#!/bin/bash

<<comment
Deploy a project
comment

clone_code() {
    if [ ! -d "django-notes-app" ]; then
        git clone https://github.com/LondheShubham153/django-notes-app.git
        echo "Cloning your repo"
    else
        echo "Code directory already exists"
    fi
}

install_requirements() {
    echo "Installing your dependencies"
    sudo apt-get update
    sudo apt-get install docker.io nginx -y
}

restart_requirements() {
    sudo chown $USER /var/run/docker.sock
    sudo systemctl enable docker
    sudo systemctl enable nginx
    sudo systemctl restart docker
}

deploy() {
    cd django-notes-app || { echo "Directory not found"; exit 1; }
    docker build -t notes-app .
    docker run -d -p 8000:8000 notes-app:latest
}

echo "******************DEPLOYMENT Start*******************"

clone_code

install_requirements || { echo "Installation failed"; exit 1; }

restart_requirements || { echo "System faults identified"; exit 1; }

deploy || { echo "Deployment failed"; exit 1; }

echo "*******************DEPLOYMENT DONE*****************"

