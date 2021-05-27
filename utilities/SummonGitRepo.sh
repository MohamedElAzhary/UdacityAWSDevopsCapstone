echo "SummonGitRepo script started ...."
cd ~

if(test -d ~/UdacityAWSDevopsCapstone)
then
	echo "Repo found"
else
	cd ~
	sudo yum install -y git
	git clone git@github.com:MohamedElAzhary/UdacityAWSDevopsCapstone.git
fi
