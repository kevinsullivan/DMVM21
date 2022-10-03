# Copyright © 2001 by the Rectors and Visitors of the University of Virginia. 

# Extend Ubunto 18.04 (As of 10/22 there seem to be missing libs needed by Dafny in 20.04)

FROM ubuntu:22.04

# Create image without any user interaction
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

SHELL ["/bin/bash", "-c"]

# Update and configure Ubuntu 
RUN apt-get clean && apt-get update -y && apt-get upgrade -y && apt-get update --fix-missing
RUN apt-get install -y locales && locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

# Install essential tools and libraries
RUN apt-get -y install lsb-release build-essential git vim wget gnupg curl unzip libssl-dev libffi-dev libconfig-dev

# Perform following actions in containers /root directory
WORKDIR /root 

# Set up bash .profile
COPY .profile.txt /root/.profile

# Install Python3
RUN apt-get -y install python3-pip python3-venv python3-dev 
ENV PYTHONIOENCODING utf-8
RUN python3 -m pip install pipx
RUN python3 -m pipx ensurepath --force 
RUN . ~/.profile

# Install Lean
RUN wget -q https://raw.githubusercontent.com/leanprover-community/mathlib-tools/master/scripts/install_debian.sh && bash install_debian.sh ; rm -f install_debian.sh && source ~/.profile

# Dafny prerequisites
# WORKDIR /opt
# RUN apt-get update && apt-get install -y apt-transport-https && apt-get update && apt-get install -y dotnet-sdk-6.0
