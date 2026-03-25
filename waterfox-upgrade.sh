#!/bin/bash
# Waterfox ------------------------------------------------------------------ #
w_release=$(curl -s https://api.github.com/repos/BrowserWorks/waterfox/releases/latest | grep -oP '"tag_name": "\K[^"]+')
waterfox=$(waterfox -v)

w_version=$(echo "$waterfox" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
if [$w_version = '']; then
	w_version=$(echo "$waterfox" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
fi

echo $w_release - $w_version

if [ "$w_version" = "$w_release" ]; then
    # TRUE
    echo ""
    echo "You have the latest version of Waterfox ($w_version)."
    echo ""
else
    # FALSE
    echo ""
    echo "Your installed version of Waterfox is $w_version, and the latest version is $w_release."
    echo ""
    killall waterfox
    rm -Rf /tmp/linux
    rm -Rf /tmp/waterfox*
	cd /tmp
	# wget https://cdn1.waterfox.net/waterfox/releases/latest/linux
	# https://cdn1.waterfox.net/waterfox/releases/6.6.5.1/Linux_x86_64/waterfox-6.6.5.1.tar.bz2
	wget https://cdn1.waterfox.net/waterfox/releases/$w_release/Linux_x86_64/waterfox-$w_release.tar.bz2
	#mv linux linux.tar.bz2
	#tar xjf linux.tar.bz2
	tar xjf waterfox-$w_release.tar.bz2
	sudo chown root:root -R waterfox
	sudo mv /opt/waterfox /opt/waterfox-$(date +%Y%m%d)-$(tr -dc A-Za-z0-9 </dev/urandom | head -c 3; echo)
	sudo mv waterfox /opt
	sudo ln -s /opt/waterfox/waterfox /usr/local/bin/waterfox
	sudo rm -Rf /tmp/linux* /tmp/waterfox*
fi
