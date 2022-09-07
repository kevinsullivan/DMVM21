# Copyright © 2001 by the Rectors and Visitors of the University of Virginia. 

# Extend Ubunto 20.04
FROM ubuntu:20.04

# Create image without any user interaction
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Let's use the bash shell rather than the default sh
SHELL ["/bin/bash", "-c"]

# Update and configure Ubuntu 
RUN apt-get clean && apt-get update -y && apt-get upgrade -y
RUN apt-get install -y locales && locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  
WORKDIR /root  
# COPY .devcontainer/.profile.txt /root/.profile
VOLUME /hostdir

# Basics
RUN apt-get -y install sudo lsb-release build-essential git wget gnupg curl libssl-dev libffi-dev libconfig-dev

# Install VSCode Live Share stuff
RUN wget -O ~/vsls-reqs https://aka.ms/vsls-linux-prereq-script && chmod +x ~/vsls-reqs && ~/vsls-reqs

# Install Python3
RUN apt-get update --fix-missing
RUN apt-get -y install python3-pip python3-venv python3-dev
ENV PYTHONIOENCODING utf-8
RUN python3 -m pip install pipx
RUN python3 -m pipx ensurepath --force && source ~/.profile

# Install Z3 Python library
RUN pip install z3-solver

# Install Lean
RUN wget -q https://raw.githubusercontent.com/leanprover-community/mathlib-tools/master/scripts/install_debian.sh && bash install_debian.sh ; rm -f install_debian.sh && source ~/.profile
