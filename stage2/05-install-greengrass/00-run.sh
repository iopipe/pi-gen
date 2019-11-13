#!/bin/bash

cat <<EOF >>${ROOTFS_DIR}/etc/sysctl.d/98-rpi.conf
fs.protected_hardlinks = 1
fs.protected_symlinks = 1
EOF

tar Czxf ${ROOTFS_DIR} files/greengrass*.tar.gz

# Users should place the extracted keys/config into the fat32 partition.
rm -rf ${ROOTFS_DIR}/greengrass/certs \
       ${ROOTFS_DIR}/greengrass/config
mkdir -p ${ROOTFS_DIR}/greengrass/certs
mkdir -p ${ROOTFS_DIR}/greengrass/config
mkdir -p ${ROOTFS_DIR}/boot/greengrass/certs
mkdir -p ${ROOTFS_DIR}/boot/greengrass/config

# copy root cert into /greengrass/certs
cp files/root.ca.pem ${ROOTFS_DIR}/greengrass/certs

# For twitch stream we want viewers to see our text BIG!
# We also don't need to waste memory on GPU by default!
cat <<EOF >>${ROOTFS_DIR}/boot/config.txt
framebuffer_width=800
framebuffer_height=400
gpu_mem=16
EOF

# Grab samples which also has the dependencies checker utility.
if [ -d ${ROOTFS_DIR}/home/pi/aws-greengrass-samples ]; then
  cd ${ROOTFS_DIR}/home/pi/aws-greengrass-samples;
  git pull --rebase origin master
else
  git clone git://github.com/aws-samples/aws-greengrass-samples ${ROOTFS_DIR}/home/pi/aws-greengrass-samples
fi
