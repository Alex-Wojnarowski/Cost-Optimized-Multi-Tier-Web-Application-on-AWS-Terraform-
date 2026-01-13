#!/bin/bash
set -euo pipefail
REGION="eu-west-1"
apt-get update -y
apt-get install -y wget nginx
SSM_URL="https://s3.amazonaws.com/amazon-ssm-${REGION}/latest/debian_amd64/amazon-ssm-agent.deb"
wget -qO /tmp/amazon-ssm-agent.deb "$SSM_URL"
dpkg -i /tmp/amazon-ssm-agent.deb || apt-get -f install -y

systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

systemctl enable nginx
systemctl start nginx