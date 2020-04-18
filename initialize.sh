#!/bin/bash
#字体颜色
blue() {
    echo -e "\033[34m\033[01m$1\033[0m"
}
green() {
    echo -e "\033[32m\033[01m$1\033[0m"
}
red() {
    echo -e "\033[31m\033[01m$1\033[0m"
}

blue "..:: You are using $(lsb_release -ds) ::.."

if [[ $EUID -eq 0 ]]; then
    red "Please run this script with sudo"
    exit 1
fi

if (! -f /etc/apt/sources.list.d/nginx.list); then
    blue "Add Nginx Official Source"

    cat >/etc/apt/sources.list.d/nginx.list <<-EOF
deb [arch=amd64] http://nginx.org/packages/mainline/ubuntu/ $(lsb_release -sc) nginx
deb-src http://nginx.org/packages/mainline/ubuntu/ $(lsb_release -sc) nginx
EOF

    wget -qO - http://nginx.org/keys/nginx_signing.key | apt-key add -

    apt update
    apt install nginx
fi

blue "Installing Docker"
curl -sS https://get.docker.com/ | sh
green "Docker installed succeed"
usermod -aG docker $USER

blue "Installing Outline"
bash -c "$(wget -qO- https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh)"
