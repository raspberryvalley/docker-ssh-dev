# Raspberry Valley image for testing Ansible scripts on Windows
# To learn more, visit our github repository: https://github.com/raspberryvalley/docker-ssh-dev

# Raspberry Valley is a makerspace in Sweden, Karlskrona. You can visit our sites and check what's developing: 
# * Knowledge base: https://raspberry-valley.azurewebsites.net
# * Github pages: https://github.com/raspberryvalley
# * Docker hub: hub.docker.com/r/raspberryvalley/
# * Follow on Twitter: https://twitter.com/RaspberryValley

FROM balenalib/amd64-debian:buster-run

LABEL maintainer = "raspberryvalley@outlook.cc"

RUN apt-get update && apt-get install -y openssh-server
EXPOSE 22

# Create a group and user account for the SSH connection
RUN groupadd sshvalley && useradd -ms /bin/bash -g sshvalley sshuser

# Use a trusted RSA key
ARG home=/home/sshuser
RUN mkdir $home/.ssh
COPY id_rsa.pub $home/.ssh/authorized_keys

RUN chown sshuser:sshvalley $home/.ssh/authorized_keys && \
    chmod 600 $home/.ssh/authorized_keys

CMD service ssh start && /bin/bash
