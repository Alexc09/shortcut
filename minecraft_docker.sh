wget -qO- https://get.docker.com/ | sh

echo -e "\e[1;31m Installing docker-compose \e[0m"

# Install docker-compose
COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oE "[0-9]+\.[0-9][0-9]+\.[0-9]+$" | sort --version-sort | tail -n 1`
sudo sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
sudo chmod +x /usr/local/bin/docker-compose
sudo sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"


echo -e "\e[1;31m Installing docker-cleanup \e[0m"

# Install docker-cleanup command
cd /tmp
git clone https://gist.github.com/76b450a0c986e576e98b.git
cd 76b450a0c986e576e98b
sudo mv docker-cleanup /usr/local/bin/docker-cleanup
sudo chmod +x /usr/local/bin/docker-cleanup

echo -e "\e[1;31m Finished with docker-cleanup \e[0m"

echo -e "\e[1;31m Creating docker-compose.yml file \e[0m"

sh -c "cat >> /home/ubuntu/docker-compose.yml << 'EOL'
version: '3'

services:
  mc:
    container_name: walkercraft
    image: itzg/minecraft-server
    ports:
      - 25565:25565
    environment:
      EULA: 'TRUE'
    tty: true
    stdin_open: true
    restart: unless-stopped
    volumes:
      # attach a directory relative to the directory containing this compose file
      - ./minecraft-data:/data

EOL"


echo -e "\e[1;31m Created docker-compose.yml file \e[0m"

cd /home/ubuntu

echo -e "\e[1;31m Starting docker container \e[0m"

# sudo screen -d -S mc_server -m && sudo docker-compose up -d && wait \ 
# && echo -e "\e[1;31m Docker container started \e[0m" \ 
# && echo -e "\e[1;31m Opening minecraft server console from container \e[0m" \ 
# && sudo docker container exec -it walkercraft rcon-cli

# sudo screen -S mc_server -dm bash -c 'sudo docker-compose up -d ; wait ; sudo docker container exec -it walkercraft rcon-cli ; exec sh'
sudo screen -S mc_server -dm bash -c 'sudo docker-compose up -d ; exec sh'
# "screen -r mc_server" to reattach to minecraft screen

# Run this to get into minecraft-cli, once docker container has started
# >sudo docker container exec -it walkercraft rcon-cli