# Use official Jenkins inbound agent image as base
FROM jenkins/inbound-agent:latest

# Switch to root to install additional tools
USER root

# Install kubectl, AWS CLI, and Docker client
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    python3-pip \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && mv kubectl /usr/local/bin/

# Switch back to Jenkins user
USER jenkins

# Set working directory
WORKDIR /home/jenkins/agent

