sudo yum -y install https://www.elrepo.org/elrepo-release-7.0-4.el7.elrepo.noarch.rpm
sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
sudo yum --disablerepo="*" --enablerepo="elrepo-kernel" list available | grep kernel-ml
sudo yum --enablerepo=elrepo-kernel install kernel-ml
sudo yum -y --enablerepo=elrepo-kernel install kernel-ml-{devel,headers,perf}
sudo awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg
sudo grub2-set-default 0
sudo shutdown -r now
