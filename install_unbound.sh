#!/bin/bash
# Set the variables for your environment
vpc_dns=${vpc_dns_address}
onprem_domain=${onprem_domain}
onprem_dns=${onprem_dns}

# Install updates and dependencies
yum update -y
yum install -y gcc openssl-devel expat-devel
# Get, build, and install latest Unbound
wget https://unbound.net/downloads/unbound-latest.tar.gz
tar -zxvf unbound-latest.tar.gz
cd unbound-*
./configure && make && make install
# Add run-time user
useradd unbound

# Write Unbound configuration file with values from variables
cat << EOF | tee /usr/local/etc/unbound/unbound.conf
server:
        interface: 0.0.0.0
        access-control: 0.0.0.0/0 allow
forward-zone:
        name: "."
        forward-addr: ${vpc_dns}
forward-zone:
        name: "${onprem_domain}"
        forward-addr: ${onprem_dns}
EOF

# Install Unbound as service and run
cat << EOF | tee /etc/init/unbound.conf
start on runlevel [2345]
exec /usr/local/sbin/unbound
EOF

start unbound
