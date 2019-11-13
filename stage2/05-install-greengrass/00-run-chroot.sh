#!/bin/sh

adduser --disabled-password -q --gecos "" ggc_user
addgroup ggc_group
adduser ggc_user ggc_group

cat <<EOF >/etc/init.d/S02greengrass
#!/bin/sh
mkdir -p /greengrass/certs
mkdir -p /greengrass/config
cp /boot/greengrass/certs/* /greengrass/certs/
cp /boot/greengrass/config/* /greengrass/config/
cd /greengrass/ggc/core
./greengrassd \$@
EOF
chmod 755 /etc/init.d/S02greengrass

cat <<EOF >/etc/systemd/system/greengrass.service
[Unit]
Description=AWS Greengrass Daemon

[Service]
Type=forking
PIDFile=/var/run/greengrassd.pid
ExecStart=/etc/init.d/S02greengrass start
ExecReload=/etc/init.d/S02greengrass restart
ExecStop=/etc/init.d/S02greengrass stop
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
systemctl enable greengrass.service
