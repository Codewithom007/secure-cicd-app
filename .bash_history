sudo apt-get update -y && sudo apt-get upgrade -y
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g pm2
node --version    
pm2 --version     
sudo mkdir -p /var/www/app
sudo chown ubuntu:ubuntu /var/www/app
history
exit
sudo apt-get update -y
sudo apt-get install -y openjdk-17-jdk
java -version
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee   /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]   https://pkg.jenkins.io/debian-stable binary/ | sudo tee   /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y jenkins
sudo apt install -y jenkins
sudo apt update -y
sudo rm -f /etc/apt/sources.list.d/jenkins.list
sudo rm -f /usr/share/keyrings/jenkins-keyring.asc
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo rm -f /etc/apt/sources.list.d/jenkins.list
sudo rm -f /usr/share/keyrings/jenkins-keyring.asc
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | gpg --dearmor | sudo tee /usr/share/keyrings/jenkins-keyring.gpg > /dev/null
sudo apt update
sudo apt install -y jenkins
cat /etc/apt/sources.list.d/jenkins.list
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list
cat /etc/apt/sources.list.d/jenkins.list
sudo apt update
sudo rm -f /usr/share/keyrings/jenkins-keyring.gpg
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.gpg
sudo chmod 644 /usr/share/keyrings/jenkins-keyring.gpg
sudo apt update
sudo apt install -y jenkins
wget https://pkg.jenkins.io/debian-stable/binary/jenkins_2.452.3_all.deb
sudo apt install -y ./jenkins_2.452.3_all.deb
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
wget https://pkg.jenkins.io/debian-stable/binary/jenkins_2.479.3_all.deb
sudo apt install -y ./jenkins_2.479.3_all.deb
sudo systemctl restart jenkins
git clone https://github.com/Codewithom007/secure-cicd-app.git
cd secure-cicd-app/
mkdir -p scripts
touch package.json server.js server.test.js Jenkinsfile
touch scripts/deploy.sh
ls
sudo nano package.json 
sudo nano server.js
sudo nano server.test.js 
ls
cd scripts/
sudo nano deploy.sh
cd ..
sudo nano Jenkinsfile 
chmod +x scripts/deploy.sh
git add .
git commit -m 'Initial: add app, tests, Jenkinsfile, deploy script'
git push origin main
wget https://pkg.jenkins.io/debian-stable/binary/jenkins_2.479.3_all.deb
sudo apt install -y ./jenkins_2.479.3_all.deb
sudo systemctl restart jenkins
git -version
git --version
wget https://pkg.jenkins.io/debian-stable/binary/jenkins_2.479.3_all.deb
sudo apt install -y ./jenkins_2.479.3_all.deb
sudo systemctl restart jenkins
