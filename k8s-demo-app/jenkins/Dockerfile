FROM jenkins/jenkins:lts-jdk17

USER root

RUN apt-get update && \
    apt-get install -y docker-cli

USER jenkins