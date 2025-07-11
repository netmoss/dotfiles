#!/bin/bash
set -e

pkgs=(virt-manager qemu-full dnsmasq spice-vdagent)
for p in "${pkgs[@]}"; do
  pacman -Q $p &>/dev/null || sudo pacman -S --noconfirm $p
done

sudo systemctl enable --now libvirtd

u=$(whoami)
groups $u | grep -qw libvirt || sudo usermod -aG libvirt $u

n=default
if ! sudo virsh -c qemu:///system net-info $n &>/dev/null; then
  uuid=$(uuidgen)
  f=/tmp/$n.xml
  cat <<EOF > $f
<network>
  <name>$n</name>
  <uuid>$uuid</uuid>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
    </dhcp>
  </ip>
</network>
EOF
  sudo virsh -c qemu:///system net-define $f
  rm $f
fi

sudo virsh -c qemu:///system net-start $n || true
sudo virsh -c qemu:///system net-autostart $n

echo "Done. Restart may be needed."

