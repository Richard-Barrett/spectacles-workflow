####################
#    BASE IMAGE    #
####################
FROM python:3.7.15-slim-bullseye as base

# LABEL about the custom image
LABEL maintainer="richard-barrett@outlook.com"
LABEL version="$(git tag --sort=committerdate | tail -1)"
LABEL description="This is custom Docker Image for OpenSource Spectacles Usage against Looker Deployments."

# Image ARGS
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt-get update -y

# Install Base Dependencies
RUN apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    tree \
    tar \
    openssl \
    make \
    git \
    zip \
    vim \
    nano \
    unzip \
    wget \
    apt-transport-https \
    python3 \
    python3-pip \
    python3-openssl \
    build-essential \ 
    libssl-dev \ 
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    llvm \ 
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev

RUN curl https://pyenv.run | bash

######################################
#      MIRANTIS_SPECTACLES IMAGE     #
######################################
FROM base as spectacles_workflow

# Set Looker ENV and ARG Variabels
ARG LOOKER_BASE_URL
ENV LOOKER_BASE_URL=${LOOKER_BASE_URL}
ARG LOOKER_CLIENTID
ENV LOOKER_CLIENTID=${LOOKER_CLIENTID}
ARG LOOKER_CLIENTSECRET
ENV LOOKER_CLIENT_SECRET=${LOOKER_CLIENTSECRET}

ENV PIP_ROOT_USER_ACTION=ignore
ENV PYTHON_CONFIGURE_OPTS --enable-shared
ENV LC_ALL C.UTF-8

# Set Up Python Virtual Environment for Spectacles
# Documentation: https://docs.spectacles.dev/cli/tutorials/getting-started
COPY . /spectacles
WORKDIR /spectacles

RUN /usr/local/bin/python -m pip install --upgrade pip

RUN export PATH="${PATH}:"$(pyenv root)/shims

CMD ["spectacles connect --base-url ${LOOKER_BASE_URL} --client-id ${LOOKER_CLIENTID --client-secret ${LOOKER_CLIENTSECRET}"]
ENTRYPOINT [ "spectacles"]



