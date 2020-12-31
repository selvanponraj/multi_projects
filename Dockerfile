# Alpine Linux along with Maven & Git
FROM maven:3-alpine
MAINTAINER Selvan Ponraj

RUN apk add --no-cache --update \
    python3 \
    python3-dev \
    py-pip \
    build-base \
    openjdk8-jre \
    git \
    openssh \
    bash \
  && pip install --upgrade pip \
  && pip install virtualenv \
  && rm -rf /var/cache/apk/*

WORKDIR /app

# RUN mkdir -p /root/.ssh
# # Add git hub private key
# ADD id_rsa /root/.ssh/id_rsa
# RUN chmod 600 /root/.ssh/id_rsa

# # Use git with SSH instead of https!
# # Skip Host verification for git
# RUN echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config