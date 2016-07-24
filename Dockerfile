# Dockerfile
 
 FROM icedmac/centos_sshd
 MAINTAINER Cedric Carregues <cedric.carregues@neuvosys.com>
 
 RUN yum clean all && \
     yum -y install epel-release && \
     yum -y install PyYAML python-jinja2 python-httplib2 python-paramiko python-setuptools git python-pip python-six
RUN mkdir /etc/ansible/
RUN echo 'localhost' > /etc/ansible/hosts

# get Ansible from GitHub
RUN git clone http://github.com/ansible/ansible.git --recursive /opt/ansible

# Checkout the revision 1.9.2
WORKDIR /opt/ansible
RUN git checkout -b v1.9.2-1 v1.9.2-1
RUN git submodule update --init --recursive

# Set the environment
ENV PATH /opt/ansible/bin:/bin:/usr/bin:/sbin:/usr/sbin
ENV PYTHONPATH /opt/ansible/lib
ENV ANSIBLE_LIBRARY /opt/ansible/library
