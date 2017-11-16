FROM ubuntu:16.04

ENV container docker

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update -qq && apt-get install --no-install-recommends -q -y curl sudo tzdata wget apt-utils dnsutils file iputils-ping net-tools nfs-common openssl syslinux sysv-rc-conf libssl1.0.0 openjdk-8-jdk && apt-get autoremove --purge -q -y && rm -rf /var/lib/apt/lists/* && apt-get clean -q

LABEL mapr.os=ubuntu16 mapr.version=5.2.2 mapr.mep_version=3.0.1

COPY mapr-setup.sh /opt/mapr/installer/docker/
RUN /opt/mapr/installer/docker/mapr-setup.sh -r http://package.mapr.com/releases container client 5.2.2 3.0.1 mapr-client mapr-posix-client-container
RUN mkdir -p /mapr

ENTRYPOINT ["/opt/mapr/installer/docker/mapr-setup.sh", "container"]

EXPOSE 1433
COPY install.sh /
COPY startup.sh /
RUN /install.sh
#Run SQL Server process.

#CMD ["bash","/startup.sh"]
CMD ["/startup.sh"]
