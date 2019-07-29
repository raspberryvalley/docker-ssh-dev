# Docker TEST Device (ansible etc.)

For our experiments with [Ansible](https://www.ansible.com) and Raspberry Pi deployment scripts, we needed a test machine for core development on our laptops. While there are plenty of guides out there for [Virtualbox](https://www.virtualbox.org/wiki/Downloads), [Vagrant](https://www.vagrantup.com) and the like, we surprisingly found little material for using Docker containers for testing deployments, i.e. containers with SSH running.

The scenario: we wish to develop deployment scripts for *Ansible*, to deploy our Raspberry Pi devices more easily. Core development is done on our Windows notebooks, and then fine-tuned against a Raspberry Pi device. As we use Docker, we wish to use a Docker solution for quickly starting up and tearing down a test machine. While many blogs and forum answers discourage the use of Docker containers with SSH servers running, this scenario is valuable for our use-case.

---

**It is not a good idea to use this image and containers based on it in production! Most importantly for architecture and security reasons. Consider this image to be a development image only.**

---

## Features

Our base image satisfies the following requirements:

* SSH access is enabled. This allows to mimick the Raspberry Pi behavior via Docker, without having to flash SD cards again and again in early development stages
* The base image is close to what we use on our Raspberry Pi: a [Balena](https://www.balena.io/docs/reference/base-images/base-images-ref/) library image with only core features. Please feel free to substitute it with an image which is closest to what you intend to base your Pi devices on. Just modify the *dockerfile* base image.

## Getting Started

Here are a few steps to follow to start using our image.

* Setup Docker. [Here](https://docs.docker.com/docker-for-windows/install/) is the official guide to setup Docker on Windows 10.
* Setup SSH on your laptop. If you are running Windows, try Powershell and OpenSSH. There's plenty of good guides available, you can use for instance this simple and clear guide: [Install OpenSSH on Windows 10](https://jcutrer.com/windows/install-openssh-on-windows10)
* pull this repository to your machine, or download the zip file
* Generate your SSH keys. There's plenty of materials available, but if you have Powershell running with OpenSSH installed, just type:

```bash
ssh-keygen
```

Your keys will be located in ```C:\Users\<your username>\.ssh```. If you stuck to defaults, the filenames will be **id_rsa** (private key) and **id_rsa.pub** (public key). Remember this path

* Copy (overwrite) the public key - **id_rsa.pub** to this repository (otherwise your build won't work). You don't need to copy the private key, but just in case, we have updated *.gitignore* with it, so you don't accidently push to your repository

* Build the image. Due to the fact that you need to provide your own SSH keys, a build on your own machine, via Docker, is the only option. Secrets should be properly guarded. See a detailed overview below. It takes a few minutes. Note down your image name and tag.

For the purpose of this guide, we use the following image name: **raspberryvalley/sshsrv:1.0**. Make up your own name.

* Run the image. Your typical scenario would be probably to run the image as a disposable container:

```bash
docker run -it --rm -p 1022 raspberryvalley/sshsrv:1.0
```

The image exposes port 22 for SSH access. As the port is most probably taken on your Windows machine, we map the port to **1022**. Remeber this, it will be used further down.

* Fire up a new terminal window (PowerShell Window) to test the connection:

```bash
ssh sshuser@localhost -p 1022 -i C:\Users\<your username>\.ssh\id_rsa
```

The SSH client connects to our brand new machine (remeber it only exists while it is running, due to the --rm parameter) on port 1022, using our own private key. This key is kept secure all the time.

### Building the Image

You need to build your image with the SSH keys you have generated in previous steps.

* copy your own PUBLIC key (id_rsa.pub) from ```C:\Users\<your username>\.ssh``` to the working directory of this repository (we have a dummy key provided here, which has to be overwritten). This step ensures your secrets are used.
* open up powershell in the working directory (where '.dockerfile' is) and type:

```bash
docker build -t "raspberryvalley/sshsrv:1.0" .
```

This will build your own server. Name the image as you wish of course.

* Done

## Links

* [Inspiration from Stevie's blog](https://www.dontpanicblog.co.uk/2018/11/30/ssh-into-a-docker-container/) and the related [Github repository](https://github.com/hotblac/nginx-ssh)
