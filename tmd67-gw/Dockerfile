FROM mcr.microsoft.com/devcontainers/python:3-bullseye

ENTRYPOINT [ "bash", "/root/entrypoint.sh" ]
CMD ["nginx", "-g", "daemon off;"]

RUN apt-get update -y
RUN apt-get install -y vim telnet gcc unzip vsftpd jq wget ntpdate iputils-ping

# sshd
RUN apt-get install -y openssh-server
RUN echo 'root:cwb+123' | chpasswd
RUN echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN mkdir /run/sshd
RUN mkdir -p /root/.ssh
COPY id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys
COPY entrypoint.sh /root/


# nginx
RUN apt-get install -y nginx
COPY nginx.conf /etc/nginx/
COPY index.html /var/www/
COPY static/ /var/www/static/
RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log
