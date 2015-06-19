#FROM ubuntu:14.04
FROM phusion/baseimage:0.9.16

 
# Install dev tools: jdk, git etc...
#RUN apt-get update
#RUN apt-get install -y openssh-server
RUN rm -f /etc/service/sshd/down
CMD ["/sbin/my_init"]
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
RUN mkdir /etc/service/runner
ADD docker/runner.sh  /etc/service/runner/run
ADD shared/keys /tmp/
RUN chmod a+r /tmp/id_rsa*
RUN cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys
RUN cp /tmp/id_rsa* /root/.ssh/
RUN groupadd vagrant
RUN useradd -g vagrant -m -G adm vagrant
ADD cookbooks/shared/files /home/vagrant
RUN sudo -u vagrant mkdir /home/vagrant/.ssh
RUN sudo -u vagrant cp /tmp/id_rsa* /home/vagrant/.ssh/
RUN sudo -u vagrant chmod go-rwx /home/vagrant/.ssh/*
RUN sudo -u vagrant cat /tmp/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
RUN rm /tmp/id_rsa*
RUN chown -R vagrant:vagrant /home/vagrant
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
