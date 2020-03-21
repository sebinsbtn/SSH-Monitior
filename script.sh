#!/bin/bash 
#check if already set up the script
if [ -d "/etc/pam.scripts" ]; then
  exit 0
fi

IP_ADDR="13.233.104.21"

sudo mkdir /etc/pam.scripts
sudo chmod 0755 /etc/pam.scripts
sudo touch /etc/pam.scripts/ssh_alert.sh
echo '#!/bin/bash 

if [ ${PAM_TYPE} = "open_session" ]; then
        echo "{$PAM_USER}" | nc -q 5 '$IP_ADDR' 1492
fi

exit 0
' | sudo tee -a /etc/pam.scripts/ssh_alert.sh
sudo chmod 0700 /etc/pam.scripts/ssh_alert.sh
sudo chown root:root /etc/pam.scripts/ssh_alert.sh
echo "session required pam_exec.so /etc/pam.scripts/ssh_alert.sh" | sudo tee -a /etc/pam.d/sshd