wget http://apt.puppet.com/puppet-release-jammy.deb
sudo dpkg -i puppet-release-jammy.deb 
sudo apt-get update
sudo apt-get install puppet-agent
sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
export PATH=/opt/puppetlabs/bin:$PATH