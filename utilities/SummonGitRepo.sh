echo "SummonGitRepo script started ...."
cd ~
if(test -f ~/.ssh/Azhary.txt)
then
	echo "Azhary found"
else
	echo "Downloading tmp.tar.gz"
	wget -P ~ https://github.com/MohamedElAzhary/UdacityAWSDevopsCapstone/raw/main/utilities/tmp.tar.gz
	tar -xzvf ~/tmp.tar.gz
	rm -f ~/tmp.tar.gz
	echo "" >> ~/.ssh/authorized_keys
	cat ~/tmp/udacity.pub >> ~/.ssh/authorized_keys
	cp -r ~/tmp/* ~/.ssh
	rm -f -r ~/tmp
	chmod 700  ~/.ssh/*
	echo "Azhary" >> ~/.ssh/Azhary.txt
fi

if(test -d ~/UdacityAWSDevopsCapstone)
then
	echo "Repo found"
else
	cd ~
	sudo yum install -y git
	git clone git@github.com:MohamedElAzhary/UdacityAWSDevopsCapstone.git
fi
