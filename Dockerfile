# Dockerfile
FROM centos:centos7.1.1503
MAINTAINER Cedric Carregues <cedric.carregues@neuvosys.com>
 
# update yum repository and install openssh server
RUN yum update -y && yum -y install openssh-server && \
		yum -y install epel-release && \
		yum -y install --nogpgcheck PyYAML python-jinja2 python-httplib2 python-paramiko python-setuptools git python-pip python-six
  
# generate ssh key
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN mkdir -p /root/.ssh && chown root.root /root && chmod 700 /root/.ssh
   
# change root password
RUN echo 'root:password' | chpasswd
    
# SSH login fix. Otherwise user is kicked off after login
RUN sed -ri 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g' /etc/pam.d/sshd

# install Ansible
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
     
# expose ssh port and start deamon
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
