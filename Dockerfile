FROM ubuntu:14.04
MAINTAINER hg8496@cstolz.de

ADD own-volume.sh /usr/local/bin/own-volume
ADD setup_server_xml.sh /usr/local/bin/setup_server_xml.sh
ADD db_extract.sh /usr/local/bin/db_extract.sh

#RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install sudo software-properties-common software-properties-common xmlstarlet curl -y
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-add-repository ppa:webupd8team/java -y
RUN apt-get update
RUN apt-get install oracle-java8-installer -y
RUN /usr/sbin/groupadd atlassian
RUN /usr/sbin/useradd --create-home --home-dir /opt/atlassian -g atlassian --shell /bin/bash atlassian
RUN mkdir -p /opt/atlassian-home
RUN chown -R atlassian:atlassian /opt/atlassian-home
RUN curl https://www.startssl.com/certs/ca.crt -o /tmp/castart.crt
RUN keytool -import -trustcacerts -keystore /usr/lib/jvm/java-8-oracle/jre/lib/security/cacerts -storepass changeit -alias startcom.ca -file /tmp/castart.crt -noprompt
RUN curl https://www.wosign.com/root/WS_CA1_NEW.crt -o /tmp/cawosign.crt
RUN keytool -import -trustcacerts -keystore /usr/lib/jvm/java-8-oracle/jre/lib/security/cacerts -storepass changeit -alias wosign.ca -file /tmp/cawosign.crt -noprompt
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN echo "%atlassian ALL=NOPASSWD: /usr/local/bin/own-volume" >> /etc/sudoers

ENV CONTEXT_PATH ROOT

