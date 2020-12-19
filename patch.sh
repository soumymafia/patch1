#!/bin/bash

echo "start update patch"
cat > /etc/openvpn/server-tcp-1194.conf <<-END
port 1194
proto tcp
dev tun
ca ca.crt
cert vpnstores.crt
key vpnstores.key
dh dh2048.pem
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login
verify-client-cert none
username-as-common-name
server 10.6.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 5 30
comp-lzo
persist-key
persist-tun
status openvpn-status.log
verb 3
END
cat > /etc/openvpn/server-udp-2200.conf <<-END
port 2200
proto udp
dev tun
ca ca.crt
cert vpnstores.crt
key vpnstores.key
dh dh2048.pem
plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login
verify-client-cert none
username-as-common-name
server 10.7.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 5 30
comp-lzo
persist-key
persist-tun
status openvpn-status.log
verb 3
END

cd /usr/bin
wget -O menu "https://raw.githubusercontent.com/soumymafia/patch1/master/menu.sh"
wget -O usernew "https://raw.githubusercontent.com/soumymafia/patch1/master/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/soumymafia/patch1/master/trial.sh"
wget -O autokill "https://raw.githubusercontent.com/soumymafia/patch1/master/autokill.sh"
wget -O tendang "https://raw.githubusercontent.com/soumymafia/patch1/master/tendang.sh"
wget -O renew "https://raw.githubusercontent.com/soumymafia/patch1/master/renew.sh"
wget -O cek "https://raw.githubusercontent.com/soumymafia/patch1/master/cek.sh"
wget -O restart "https://raw.githubusercontent.com/soumymafia/patch1/master/restart.sh"
wget -O ssradd "https://raw.githubusercontent.com/soumymafia/patch1/master/ssradd.sh"
wget -O ssrdel "https://raw.githubusercontent.com/soumymafia/patch1/master/ssrdel.sh"
wget -O ssr "https://raw.githubusercontent.com/soumymafia/patch1/master/ssrmu.sh"
wget -O addvpn "https://raw.githubusercontent.com/soumymafia/patch1/master/addvpn.sh"
wget -O delvpn "https://raw.githubusercontent.com/soumymafia/patch1/master/delvpn.sh"
wget -O v2ray "https://raw.githubusercontent.com/soumymafia/soumysc/master/v2ray.sh"
wget -O about "https://raw.githubusercontent.com/soumymafia/soumysc/master/about.sh"
wget -O info "https://raw.githubusercontent.com/soumymafia/soumysc/master/info.sh"
chmod +x menu
chmod +x usernew
chmod +x trial
chmod +x autokill
chmod +x tendang
chmod +x renew
chmod +x cek
chmod +x restart
chmod +x ssradd
chmod +x ssrdel
chmod +x ssr
chmod +x addvpn
chmod +x delvpn
chmod +x v2ray
chmod +x about
chmod +x info
echo " selesai meng-update patch"
