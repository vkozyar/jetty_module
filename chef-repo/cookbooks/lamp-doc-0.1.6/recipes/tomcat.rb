bash "install_jetty" do
  code <<-EOL
  JETTY_HOME=/home/jetty/jetty
  JETTY_DIR=/home/jetty
  if [ ! -d /home/jetty ]; then
    useradd -d /home/jetty -m -p jetty jetty
    mkdir /home/jetty/jetty
  fi
  wget http://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/9.3.9.v20160517/jetty-distribution-9.3.9.v20160517.tar.gz -O /tmp/jetty-distribution-9.3.9.v20160517.tar.gz
  tar -xzvf /tmp/jetty-distribution-9.3.9.v20160517.tar.gz -C /tmp/
  mv /tmp/jetty-distribution-9.3.9.v20160517 /home/jetty/jetty
  echo export JENKINS_HOME=/home/jetty/ > /etc/default/jetty
  echo export JETTY_HOME=/home/jetty/jetty >> /etc/default/jetty
  echo export JENKINS_HOME=/home/jetty/ > /etc/profile.d/systemwide.sh
  echo export JETTY_HOME=/home/jetty/jetty >> /etc/profile.d/systemwide.sh
  chmod 755 /etc/profile.d/systemwide.sh
  sh /etc/profile.d/systemwide.sh
  ipaddr=`ifconfig | grep inet | grep addr | grep Bcast | awk -F: '{print $2}' | awk -F' ' '{print $1}'`
  echo "${ipaddr} jetty.nod" >> /etc/hosts

  ### Create ssl cerificates
  if [ ! -f /home/jetty/etc/keystore ]; then
    cp /home/userlamp/chef-repo/cookbooks/lamp-doc-0.1.6/templates/keystore /home/jetty/jetty/etc/keystore
    chown jetty:jetty /home/jetty/jetty/etc/keystore
  fi

  cp /home/jetty/jetty/bin/jetty.sh /etc/init.d/jetty
  #sed -i 's/\# JETTY_ARGS=jetty.ssl.port=8443/JETTY_ARGS=jetty.ssl.port=8443/g' /etc/init.d/jetty
  #sed -i 's/"-Djetty.home=$JETTY_HOME"/"-Djetty.http.host=${ipaddr}" "-Djetty.home=$JETTY_HOME"/g' /etc/init.d/jetty   
  sed -i "s/"-Djetty.home=$JETTY_HOME"/"-Djetty.http.host=$ipaddr\"" \""-Djetty.home=$JETTY_HOME"/g" /etc/init.d/jetty 
  wget https://updates.jenkins-ci.org/download/war/2.8/jenkins.war -O $JETTY_HOME/webapps/jenkins.war
  chkconfig jetty on
  EOL
end



template '/home/jetty/jetty/webapps/jenkins.xml' do
  mode '0755'
  source 'jenkins.xml.erb'
  not_if do
    File.exist?('/home/jetty/jetty/webapps/jenkins.xml')
  end
end

template '/home/jetty/jetty/etc/keystore' do
  mode '0644'
  source 'keystore.erb'
  owner 'jetty'
  group 'jetty'
  not_if do
    File.exist?('/home/jetty/jetty/etc/keystore')
  end
end

service 'jetty' do
  action :start
  ignore_failure true
end

#  service jetty status | grep "NOT"
#  if [ $? == 0 ]; then 
#    service jetty start
#  fi
#  EOL
#end
