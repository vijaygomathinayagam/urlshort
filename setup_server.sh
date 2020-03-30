if [ $(id -u) -eq 0 ]; then

	$HOME=/home/urlshort

	# update repo
	apt update -y

	# setup nginx
	apt install -y nginx

	# install docker
	apt install -y \
    		apt-transport-https \
    		ca-certificates \
    		curl \
    		gnupg-agent \
    		software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
	add-apt-repository \
   		"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   		$(lsb_release -cs) \
   		stable"
	apt update -y
	apt install -y docker-ce docker-ce-cli containerd.io

	# install docker compose
	curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose

	# create workspace
	mkdir $HOME/workspace

	# cloning repos
	git clone https://github.com/vijaygomathinayagam/RequestLimiter.git $HOME/workspace
	git clone https://github.com/vijaygomathinayagam/URLShorteningServiceBackend.git $HOME/workspace
	git clone https://github.com/vijaygomathinayagam/URLShortenerFrontend.git $HOME/workspace

	# configuring nginx
	rm /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
	cp nginx/nginx.conf /etc/nginx/sites-available/.
	ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf
	systemctl restart nginx

	# run application
	docker-compose -f $HOME/workspace/RequestLimiter/docker-compose.yml up
	docker-compose -f $HOME/workspace/URLShorteningServiceBackend/docker-compose.yml up
	docker-compose -f $HOME/workspace/URLShortenerFrontend/docker-compose.yml up
else
	echo "Please run the script as root"
	exit 1
fi

