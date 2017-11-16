FROM ubuntu:16.04

ENV container docker

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update -qq && apt-get install --no-install-recommends -q -y curl sudo tzdata wget apt-utils dnsutils file iputils-ping net-tools nfs-common openssl syslinux sysv-rc-conf libssl1.0.0 openjdk-8-jdk && apt-get autoremove --purge -q -y && rm -rf /var/lib/apt/lists/* && apt-get clean -q

LABEL mapr.os=ubuntu16 mapr.version=5.2.2 mapr.mep_version=3.0.1

RUN wget http://package.mapr.com/releases/installer/ubuntu/mapr-setup.sh -O /mapr-setup.sh
COPY /mapr-setup.sh /
RUN /mapr-setup.sh -r http://package.mapr.com/releases container client 5.2.2 3.0.1 mapr-client mapr-posix-client-container
RUN mkdir -p /mapr

ENTRYPOINT ["/mapr-setup.sh", "container"]

EXPOSE 1433
RUN wget https://raw.githubusercontent.com/jsunmapr/pacc-mssql/master/install.sh -O /install.sh
COPY /install.sh /
RUN wget https://raw.githubusercontent.com/jsunmapr/pacc-mssql/master/startup.sh -O /startup.sh
COPY /startup.sh /
RUN chmod 755 /install.sh
RUN chmod 755 /startup.sh
RUN /install.sh

#Run SQL Server process.
CMD ["/startup.sh"]
