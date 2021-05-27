cd ~
echo "Downloading tmp.tar.gz"
wget -P ~ https://github.com/MohamedElAzhary/UdacityAWSDevopsCapstone/raw/main/utilities/tmp.tar.gz
tar -xzvf ~/tmp.tar.gz
rm -f ~/tmp.tar.gz
echo "" >> ~/.ssh/authorized_keys
cat ~/tmp/id_rsa.pub >> ~/.ssh/authorized_keys
cp -r ~/tmp/* ~/.ssh
rm -f -r ~/tmp
sudo chmod +rwx ~/.ssh/*

git clone git@github.com:MohamedElAzhary/UdacityAWSDevopsCapstone.git