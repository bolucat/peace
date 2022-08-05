#!/usr/bin/env bash
#
# Only for Debian 10.0 and 11.0

VERSION=$1

[ -z "$VERSION" ] && VERSION="1.19.2"

red='\033[0;31m'
plain='\033[0m'

[[ $EUID -ne 0 ]] && echo -e "[${red}Error${plain}] This script must be run as root!" && exit 1

if [ -f /etc/os-release ]; then
    export SYSTEM=$(awk -F'[= "]' '/PRETTY_NAME/{print $3}' /etc/os-release | cut -d ' ' -f1)
    if [ "$SYSTEM" == "Debian" ]; then
        export VERSION=$(awk -F'[= "]' '/VERSION_ID/{print $3}' /etc/os-release)
        if [[ "$VERSION" == "11" || "$VERSION" == "10" ]]; then
            sudo apt install -y wget aria2 > /dev/null 2>&1
            if [ $? -ne 0 ]; then
                echo -e "[${red}Error${plain}] Please install wget and aria2 first!"
                exit 1
            fi
        else
            echo -e "[${red}Error${plain}] Your system is not supported!" && exit 1
        fi
    else
        echo -e "[${red}Error${plain}] Your system is not supported!" && exit 1
    fi
else
    echo -e "[${red}Error${plain}] Your system is not supported!" && exit 1
fi

RAM=$(free -m | awk '/Mem/ {print $2}')
SWAP=$(free -m | awk '/Swap/ {print $2}')

if [ "$RAM" -lt "950" ]; then
    echo "Not enough RAM"
    exit 1
else
    if [ "$SWAP" -lt "450" ]; then
        echo "adding swap"
        sudo dd if=/dev/zero of=/usr/local/swapfile bs=1M count=2048
        sudo chmod 600 /usr/local/swapfile
        sudo mkswap /usr/local/swapfile && swapon /usr/local/swapfile
        sudo echo "/usr/local/swapfile swap swap defaults 0 0" >> /etc/fstab
    fi
fi

# install Java17
echo "install Java17"
sudo apt install -y openjdk-17-jre openjdk-17-jdk > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "install Java17 failed"
    exit 1
fi

java -version > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Java is not installed"
    exit 1
fi

# install Minecraft
echo "Downloading Minecraft v${VERSION}"
mkdir -p /usr/local/minecraft
aria2c -c -x 16 -s 16 -k 1M -d /usr/local/minecraft/ -o server.jar "https://dl.neuq.de/https://github.com/bolucat/minecraft-mirror/releases/download/${VERSION}/minecraft_server-${VERSION}.jar"

# add user
sudo adduser --system --group --no-create-home --disabled-login --disabled-password --gecos "Minecraft Server" minecraft

# systemd
cat > /etc/systemd/system/minecraft.service << EOF
[Unit]
Description=Minecraft Server
After=getty.service

[Install]
WantedBy=multi-user.target
Alias=minecraft.service

[Service]
WorkingDirectory=/usr/local/minecraft
User=minecraft
Group=minecraft
Restart=on-failure
RestartSec=20 5
ExecStart=/usr/bin/java -Xms1024M -Xmx2048M -jar server.jar nogui
StandardInput=tty-force
TTYVHangup=yes
TTYPath=/dev/tty20
TTYReset=yes
Type=simple
RemainAfterExit=false
EOF

systemctl daemon-reload

# initialize
pushd /usr/local/minecraft || exit 1
java -Xms1024M -Xmx2048M -jar server.jar nogui
popd || exit 1
sed -i 's/eula=false/eula=true/g' /usr/local/minecraft/eula.txt
mkdir -p /usr/local/minecraft/.minecraft

# give permission
chown -R minecraft:minecraft /usr/local/minecraft/.*
chown -R minecraft:minecraft /usr/local/minecraft/*

echo "Done"
