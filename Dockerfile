# Raspberry Valley image for testing Ansible scripts on Windows
# To learn more, visit our github repository: 

# Raspberry Valley is a makerspace in Sweden, Karlskrona. You can visit our site: https://raspberry-valley.azurewebsites.net

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
