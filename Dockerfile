FROM ubuntu:14.04
MAINTAINER hg8496@cstolz.de

ADD own-volume.sh /usr/local/bin/own-volume

#RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install sudo software-properties-common software-properties-common xmlstarlet curl -y
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-add-repository ppa:webupd8team/java -y
RUN apt-get update
RUN apt-get install oracle-java8-installer -y
RUN /usr/sbin/groupadd atlassian
RUN /usr/sbin/useradd --create-home --home-dir /opt/atlassian --groups atlassian --shell /bin/bash atlassian
RUN mkdir -p /opt/atlassian-home
RUN chown -R atlassian:atlassian /opt/atlassian-home
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/jira.tar.gz
RUN echo "%atlassian ALL=NOPASSWD: /usr/local/bin/own-volume" >> /etc/sudoers

ENV CONTEXT_PATH ROOT
