#!/bin/bash
set -eux

# Update system packages
dnf update -y

# Install AWS CLI v2
dnf install -y aws-cli

# Install kubelet dependencies
dnf install -y curl jq tar

# Add Kubernetes repo
cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Install kubelet
dnf install -y kubelet

# Enable and start kubelet service
systemctl enable --now kubelet
