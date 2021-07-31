FROM container-registry.oracle.com/database/enterprise:19.3.0.0
USER root
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
  yum -y install rlwrap

USER oracle
ADD --chown=oracle:oinstall files/bashrc .bashrc
