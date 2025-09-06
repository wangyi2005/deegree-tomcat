#-------swap---------------
cd /usr
mkdir swap
dd if=/dev/zero of=/usr/swap/swapfile bs=1M count=1024
du -sh /usr/swap/swapfile
mkswap /usr/swap/swapfile
free -m
nano /etc/fstab
#add this line
/usr/swap/swapfile swap swap defaults 0 0

#-----------setup cert--------------
apt install certbot
certbot certonly --standalone --key-type rsa --agree-tos --email tanghb2005@gmail.com -d ocv.wangyi2020.tk
#/etc/letsencrypt/live/ocv.wangyi2020.tk/fullchain.pem
#/etc/letsencrypt/live/ocv.wangyi2020.tk/privkey.pem
certbot renew --key-type rsa --cert-name ocv.wangyi2020.tk --force-renewal

#-----------install java17-------------
java -version
apt install openjdk-17-jre-headless

#-----------install tomcat10------------
#apt install tomcat9 --error
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.44/bin/apache-tomcat-10.1.44.zip
mkdir /usr/share/tomcat10
mv apache-tomcat-10.1.44.zip /usr/share/tomcat9
cd /usr/share/tomcat10
unzip apache-tomcat-10.1.44.zip
cd apache-tomcat-10.1.44/bin
chmod +x startup.sh shutdown.sh catalina.sh

#--------install deegree------------------
cd /usr/share/tomcat10/apache-tomcat-10.1.44/webapps
#delete other apps
rm -rf docs examples manager host-manager ROOT
wget https://repo.deegree.org/content/repositories/public/org/deegree/deegree-webservices/3.6.0/deegree-webservices-3.6.0.war
mv deegree-webservices-3.6.0.war deegree.war

#--------create deegree.service
nano /etc/systemd/system/deegree.service
#-------

#--------modify tomcat9 server.xml  maxThreads="20" acceptCount="20" --------
nano /usr/share/tomcat10/apache-tomcat-10.1.44/conf/server.xml
<!--
    <Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443"
               maxParameterCount="1000"
               />
    -->
 <Connector port="443" protocol="org.apache.coyote.http11.Http11NioProtocol"
               maxThreads="20" acceptCount="20" SSLEnabled="true"
               maxParameterCount="1000" compression="on"
               >
        <SSLHostConfig>
            <Certificate certificateKeyFile="/etc/letsencrypt/live/ocv.wangyi2020.tk/privkey.pem"
                         certificateFile="/etc/letsencrypt/live/ocv.wangyi2020.tk/cert.pem"
                         certificateChainFile="/etc/letsencrypt/live/ocv.wangyi2020.tk/fullchain.pem"
                         type="RSA" />
        </SSLHostConfig>
    </Connector>
    
