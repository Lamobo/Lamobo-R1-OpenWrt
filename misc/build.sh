#!/bin/bash

if [ -z $OPENWRT_HOME ]; then
	OPENWRT_HOME=$PWD
fi

# Install feeds packages
./scripts/feeds update
./scripts/feeds install -a

# Make Openwrt
echo "Start to make OpenWRT..."
cd $OPENWRT_HOME
cp $OPENWRT_HOME/misc/configuration $OPENWRT_HOME/.config
make -j4 V=s

